part of 'download_file_bloc.dart';

@immutable
abstract class DownloadFileState {}

class DownloadFileInitial extends DownloadFileState {}

class DownloadFileLoading extends DownloadFileState {
  int now;
  int count;
  CancelToken cancelToken;

  DownloadFileLoading(this.cancelToken, this.now, this.count);
}

class DownloadFileError extends DownloadFileState {
  int now;
  int count;

  DownloadFileError(this.now, this.count);
}

class DownloadFileSuccess extends DownloadFileState {
  File file;

  DownloadFileSuccess(this.file);
}
