part of 'send_message_bloc.dart';

@immutable
abstract class SendMessageEvent {}

class SendMessageCancelEvent extends SendMessageEvent {
  List<Key> widgetKeys;

  SendMessageCancelEvent(this.widgetKeys);
}

class SendMessageRequestModel {
  int chatId;
  List<MapEntry<String, dio.MultipartFile>>? files;
  List<File>? files2;
  String? message;
  ChatMessage? replyMessage;
  ChatMessageUploadController controller;
  Key widgetKey;

  SendMessageRequestModel({
    required this.chatId,
    required this.controller,
    required this.widgetKey,
    this.message,
    this.files,
    this.files2,
    this.replyMessage,
  });
}

class SendMessageRequestEvent extends SendMessageEvent {
  SendMessageRequestModel requestModel;

  SendMessageRequestEvent(this.requestModel);
}

class AddToSendQueueEvent extends SendMessageEvent {
  int chatId;
  List<File>? files;
  String? message;
  ChatMessage? replyMessage;
  ChatMessageUploadController controller;
  Key widgetKey;

  AddToSendQueueEvent({
    required this.chatId,
    required this.widgetKey,
    required this.controller,
    this.message,
    this.files,
    this.replyMessage,
  });

  Future<List<MapEntry<String, dio.MultipartFile>>?> getFiles() async {
    if (files == null) return null;

    List<MapEntry<String, dio.MultipartFile>> list = [];

    for (File file in files!) {
      list.add(MapEntry("file", await dio.MultipartFile.fromFile(file.path)));
    }

    return list;
  }
}
