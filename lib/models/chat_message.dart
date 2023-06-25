import 'package:siraf3/enums/message_owner.dart';

class ChatMessage {
  int? id;
  String? message;
  String? createDate;
  String? modifyDate;
  int? type;
  List<ChatFileMessage>? fileMessages;
  int? userId;
  dynamic replyId;
  int? chatId;
  bool? isConsultant;
  int? consultantFileId;
  String? timeAgo;

  MessageOwner get owner => isConsultant == true ? MessageOwner.ForHer : MessageOwner.ForME;

  static List<ChatMessage> fromList(List<dynamic> list) {
    List<ChatMessage> newList = [];

    for (Map<String, dynamic> item in list) {
      newList.add(ChatMessage.fromJson(item));
    }
    return newList;
  }

  ChatMessage.fromJson(dynamic json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["message"] is String) {
      message = json["message"];
    }
    if (json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if (json["modifyDate"] is String) {
      modifyDate = json["modifyDate"];
    }
    if (json["type"] is int) {
      type = json["type"];
    }
    if (json["fileMessage"] is List) {
      fileMessages = (json["fileMessage"] as List).map((e) => ChatFileMessage.fromJson(e)).toList();
    }
    if (json["user_id"] is int) {
      userId = json["user_id"];
    }
    replyId = json["reply_id"];
    if (json["chat_id"] is int) {
      chatId = json["chat_id"];
    }
    if (json["isConsultant"] is bool) {
      isConsultant = json["isConsultant"];
    }
    if (json["consultantFile_id"] is int) {
      consultantFileId = json["consultantFile_id"];
    }
    if (json["timeAgo"] is String) {
      timeAgo = json["timeAgo"];
    }
  }
}

class ChatFileMessage {
  int? id;
  String? path;
  String? type;
  String? fileSize;
  String? originName;
  String? uploadedPath;

  String get name => Uri.decodeFull(this.path!).replaceAll("\\", "/").split("/").last;

  String get extension => this.path!.split(".").last;

  ChatFileMessage.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["path"] is String) {
      path = json["path"];
    }
    if (json["type"] is String) {
      type = json["type"];
    }
    if (json["fileSize"] is String) {
      fileSize = json["fileSize"];
    }
    if (json["fileName"] is int) {
      originName = json["fileName"] + "." + extension;
    }
  }

  String? get getFileName {
    if (path == null) return null;

    return path!.split('/').last;
  }

  static List<ChatFileMessage> fromList(List<dynamic> list) {
    var list2 = <ChatFileMessage>[];

    for (dynamic item in list) {
      list2.add(ChatFileMessage.fromJson(item));
    }

    return list2;
  }
}
