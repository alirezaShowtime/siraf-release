import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/bloc/request_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/ticket_details.dart';

part 'ticket_download_file_event.dart';

part 'ticket_download_file_state.dart';

class TicketDownloadFileBloc extends RequestBloc<TicketDownloadFileEvent, TicketDownloadFileState> {
  TicketDownloadFileBloc() : super(TicketDownloadFileInitial()) {
    on<TicketDownloadFileRequest>(_download);
    on<TicketDownloadFileIsExist>(_isExistFile);
    on<TicketDownloadFileResume>(_downloadResume);
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

  FutureOr<void> _download(TicketDownloadFileRequest event, Emitter<TicketDownloadFileState> emit) async {
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
      emit(TicketDownloadFileLoading(cancelToken, now, count));
    };

    try {
      var downloadedFile = await _downloadWithHandler(
        url: event.url,
        savedPath: await event.savingPath(),
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      emit(TicketDownloadFileSuccess(downloadedFile));
    } on FileSystemException catch (e) {
    } on Exception catch (e) {
      emit(TicketDownloadFileError(nowDownload, countDownload));
    }
  }

  FutureOr<void> _isExistFile(TicketDownloadFileIsExist event, Emitter<TicketDownloadFileState> emit) async {
    var fileInDownload = File(await event.savingPath());

    if (await fileInDownload.exists()) {
      return emit(TicketDownloadFileSuccess(fileInDownload));
    }
  }

  FutureOr<void> _downloadResume(TicketDownloadFileResume event, Emitter<TicketDownloadFileState> emit) async {
    add(TicketDownloadFileRequest(event.fileMessage));
    return;

    int downloaded;
    File file;

    try {
      file = File(await event.savingPath());

      downloaded = await file.length();
    } on PathNotFoundException catch (e) {
      add(TicketDownloadFileRequest(event.fileMessage));

      return;
    }

    int? count = await getFileSizeFromUrl(event.fileMessage);

    if (count == null) {
      return emit(TicketDownloadFileError(0, 0));
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
      emit(TicketDownloadFileLoading(cancelToken, now, count));
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

      emit(TicketDownloadFileSuccess(file));
    } on Exception catch (e) {
      emit(TicketDownloadFileError(nowDownload, countDownload));
    }
  }

  Future<int?> getFileSizeFromUrl(FileMessage fileMessage) async {
    var res = await dio.Dio().head(fileMessage.path!);

    if (res.statusCode != 200) return null;

    return int.parse(res.headers.value("content-length")!);
  }
}
