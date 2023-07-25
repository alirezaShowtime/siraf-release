part of 'download_file_bloc.dart';

@immutable
abstract class DownloadFileEvent {
  ChatFileMessage fileMessage;

  DownloadFileEvent(this.fileMessage);

  Future<String> savingPath({bool replace = true}) async {
    Directory directory = await chatDownloadPath();

    var path = "${directory.path}/${generateMd5(fileMessage.name)}.${fileMessage.extension}";
    if (replace && await File(path).exists()) {
      return generateUniquePath(path);
    }

    return path;
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
