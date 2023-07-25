import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/bloc/request_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/chat_message.dart';

part 'download_file_event.dart';
part 'download_file_state.dart';

class DownloadFileBloc extends RequestBloc<DownloadFileEvent, DownloadFileState> {
  DownloadFileBloc() : super(DownloadFileInitial()) {
    on<DownloadFileRequest>(_download);
    on<DownloadFileIsExist>(_isExistFile);
    on<DownloadFileResume>(_downloadResume);
  }

  Future<File> _downloadWithHandler({
    required String url,
    required String savedPath,
    required dio.Options options,
    required dio.CancelToken cancelToken,
    required void Function(int, int) onReceiveProgress,
  }) async {
    try {
      await dio.Dio().download(
        url,
        savedPath,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return File(savedPath);
    } on FileSystemException catch (e) {
      print(e);

      if (e.osError?.errorCode == 17) {
        return _downloadWithHandler(
          url: url,
          savedPath: generateUniquePath(e.path!),
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        );
      }
      throw e;
    }
  }

  FutureOr<void> _download(DownloadFileRequest event, Emitter<DownloadFileState> emit) async {
    dio.Options options = dio.Options(
      responseType: dio.ResponseType.bytes,
      followRedirects: false,
      validateStatus: (_) => true,
    );

    dio.CancelToken cancelToken = dio.CancelToken();
    cancelTokens.add(cancelToken);

    int nowDownload = 0;
    int countDownload = 0;

    var onReceiveProgress = (int now, int count) {
      nowDownload = now;
      countDownload = count;
      emit(DownloadFileLoading(cancelToken, now, count));
    };

    try {
      var downloadedFile = await _downloadWithHandler(
        url: event.url,
        savedPath: await event.savingPath(),
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      emit(DownloadFileSuccess(downloadedFile));
    } on FileSystemException catch (e) {
    } on Exception catch (e) {
      emit(DownloadFileError(nowDownload, countDownload));
    }
  }

  FutureOr<void> _isExistFile(DownloadFileIsExist event, Emitter<DownloadFileState> emit) async {
    var fileInDownload = File(await event.savingPath(replace: false));

    if (await fileInDownload.exists()) {
      return emit(DownloadFileSuccess(fileInDownload));
    }
  }

  FutureOr<void> _downloadResume(DownloadFileResume event, Emitter<DownloadFileState> emit) async {
    add(DownloadFileRequest(event.fileMessage));
    return;

    int downloaded;
    File file;

    try {
      file = File(await event.savingPath());

      downloaded = await file.length();
    } on PathNotFoundException catch (e) {
      add(DownloadFileRequest(event.fileMessage));

      return;
    }

    int? count = await getFileSizeFromUrl(event.fileMessage);

    if (count == null) {
      return emit(DownloadFileError(0, 0));
    }

    dio.Options options = dio.Options(
      responseType: dio.ResponseType.bytes,
      followRedirects: false,
      validateStatus: (_) => true,
      headers: {
        "Range": "bytes=${count - downloaded}-",
      },
    );

    dio.CancelToken cancelToken = dio.CancelToken();

    int nowDownload = 0;
    int countDownload = 0;

    var onReceiveProgress = (int now, int count) {
      nowDownload = now;
      countDownload = count;
      emit(DownloadFileLoading(cancelToken, now, count));
    };

    try {
      dio.Response response = await dio.Dio().get(
        event.url,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      var ref = await file.open(mode: FileMode.append);
      await ref.writeFrom(response.data);
      await ref.close();

      emit(DownloadFileSuccess(file));
    } on Exception catch (e) {
      emit(DownloadFileError(nowDownload, countDownload));
    }
  }

  Future<int?> getFileSizeFromUrl(ChatFileMessage fileMessage) async {
    var res = await dio.Dio().head(fileMessage.path!);

    if (res.statusCode != 200) return null;

    return int.parse(res.headers.value("content-length")!);
  }
}
