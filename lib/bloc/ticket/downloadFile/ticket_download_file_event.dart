part of 'ticket_download_file_bloc.dart';

@immutable
abstract class TicketDownloadFileEvent {

  FileMessage fileMessage;

  TicketDownloadFileEvent(this.fileMessage);

  Future<String> savingPath() async {
    Directory directory = await ticketDownloadPath();

    return "${directory.path}/${generateMd5(fileMessage.name)}.${fileMessage.extension}";
  }

}

class TicketDownloadFileIsExist extends TicketDownloadFileEvent {

  TicketDownloadFileIsExist(super.fileMessage);
}

class TicketDownloadFileResume extends TicketDownloadFileEvent {
  late String url;

  TicketDownloadFileResume(super.fileMessage) {
    this.url = fileMessage.path!;
  }
}

class TicketDownloadFileRequest extends TicketDownloadFileEvent {
  late String url;

  TicketDownloadFileRequest(super.fileMessage) {
    this.url = fileMessage.path!;
  }
}
