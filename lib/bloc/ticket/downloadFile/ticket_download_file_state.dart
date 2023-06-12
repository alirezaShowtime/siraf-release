part of 'ticket_download_file_bloc.dart';

@immutable
abstract class TicketDownloadFileState {}

class TicketDownloadFileInitial extends TicketDownloadFileState {}

class TicketDownloadFileLoading extends TicketDownloadFileState {
  int now;
  int count;
  CancelToken cancelToken;

  TicketDownloadFileLoading(this.cancelToken, this.now, this.count);
}

class TicketDownloadFileError extends TicketDownloadFileState {
  int now;
  int count;

  TicketDownloadFileError(this.now, this.count);
}

class TicketDownloadFileSuccess extends TicketDownloadFileState {
  File file;

  TicketDownloadFileSuccess(this.file);
}
