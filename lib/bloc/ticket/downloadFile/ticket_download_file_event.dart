part of 'ticket_download_file_bloc.dart';

@immutable
abstract class TicketDownloadFileEvent {
  FileMessage fileMessage;

  TicketDownloadFileEvent(this.fileMessage);

  Future<String> savingPath() async {
    Directory directory = await ticketDownloadPath();

    var path = "${directory.path}/${generateMd5(fileMessage.name)}.${fileMessage.extension}";
    if (await File(path).exists()) {
      return generateUniquePath(path);
    }

    return path;
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
