import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:siraf3/bloc/request_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/chat_message.dart';

part 'download_file_event.dart';
part 'download_file_state.dart';

class DownloadFileBloc extends RequestBloc<DownloadFileEvent, DownloadFileState> {
  DownloadFileBloc() : super(DownloadFileInitial()) {
    on<DownloadFileRequest>(_download);
    on<DownloadFileIsExist>(_isExistFile);
  }

  Future<File> _downloadWithHandler({
    required String url,
    required String savedPath,
    required dio.Options options,
    required dio.CancelToken cancelToken,
    required void Function(int, int) onReceiveProgress,
  }) async {
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      await Permission.storage.request();
    }
    
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
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      await Permission.storage.request();
    }
    
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

  Future<int?> getFileSizeFromUrl(ChatFileMessage fileMessage) async {
    var res = await dio.Dio().head(fileMessage.path!);

    if (res.statusCode != 200) return null;

    return int.parse(res.headers.value("content-length")!);
  }
}
