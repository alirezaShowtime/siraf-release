part of 'download_file_bloc.dart';

@immutable
abstract class DownloadFileEvent {
  ChatFileMessage fileMessage;

  DownloadFileEvent(this.fileMessage);

  Future<String> savingPath() async {
    Directory directory = await chatDownloadPath();

    return "${directory.path}/${generateMd5(fileMessage.name)}.${fileMessage.extension}";
  }
}

class DownloadFileIsExist extends DownloadFileEvent {
  DownloadFileIsExist(super.fileMessage);
}

class DownloadFileResume extends DownloadFileEvent {
  late String url;

  DownloadFileResume(super.fileMessage) {
    this.url = fileMessage.path!;
  }
}

class DownloadFileRequest extends DownloadFileEvent {
  late String url;

  DownloadFileRequest(super.fileMessage) {
    this.url = fileMessage.path!;
  }
}
