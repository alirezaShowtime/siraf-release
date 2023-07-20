import 'package:siraf3/enums/message_owner.dart';
import 'package:siraf3/extensions/list_extension.dart';

enum TypeFile { Image, Video, Doc, Voice }

class ChatMessage {
  int? id;
  String? message;
  String? createDate;
  int? type;
  List<ChatFileMessage>? fileMessages;
  int? userId;
  int? replyId;
  ChatMessage? reply;
  int? chatId;
  bool isSearch = false;
  bool? isConsultant;
  int? consultantFileId;
  ChatMessage? replyMessage;
  String? createTime;
  bool isSeenByUser = false;
  bool isSeenByConsultant = false;

  MessageOwner get owner => isConsultant != true ? MessageOwner.ForMe : MessageOwner.ForHer;

  bool get forMe => isConsultant != true;

  bool get isSeen => forMe ? isSeenByConsultant : isSeenByUser;

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
    if (json["isSearch"] is bool) {
      isSearch = json["isSearch"];
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
    if (json["reply_id"] is int) {
      replyId = json["reply_id"];
    }
    if (json["chat_id"] is int) {
      chatId = json["chat_id"];
    }
    if (json["isConsultant"] is bool) {
      isConsultant = json["isConsultant"];
    }
    if (json["isSeen"] is bool) {
      isSeenByUser = json["isSeen"];
    }
    if (json["isSeenByConsultant"] is bool) {
      isSeenByConsultant = json["isSeenByConsultant"];
    }
    if (json["consultantFile_id"] is int) {
      consultantFileId = json["consultantFile_id"];
    }

    if (json["messageCreateTime"] is String) {
      createTime = json["messageCreateTime"];
    }
    if (json["messageCreateDate"] is String) {
      createDate = json["messageCreateDate"];
    }
    if (json["reply"] is Map) {
      reply = ChatMessage.fromJson(json["reply"]);
    }
  }

  bool _isVideos() {
    if (fileMessages!.length > 1) return false;

    for (var file in fileMessages!) {
      if (!file.isVideo) return false;
    }
    return true;
  }

  bool _isImage() {
    for (var file in fileMessages!) {
      if (!file.isImage) return false;
    }
    return true;
  }

  bool _isVoice() {
    for (var file in fileMessages!) {
      if (!file.isVoice) return false;
    }
    return true;
  }

  TypeFile? getTypeFile() {
    if (!fileMessages.isFill()) {
      return null;
    } else if (_isVideos()) {
      return TypeFile.Video;
    } else if (_isImage()) {
      return TypeFile.Image;
    } else if (_isVoice()) {
      return TypeFile.Voice;
    } else {
      return TypeFile.Doc;
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

  ChatFileMessage(this.path);

  String get name => Uri.decodeFull(this.path!).replaceAll("\\", "/").split("/").last;

  String get extension => this.path!.split(".").last;

  bool get isVideo => ["mp4", "mkv"].contains(extension);

  bool get isImage => ["png", "jpg"].contains(extension);

  bool get isVoice => ["mp3", "wav"].contains(extension);

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
    if (json["size"] is String) {
      fileSize = json["size"];
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
