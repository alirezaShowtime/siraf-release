class ChatItem {
  int? id;
  ChatLastMessage? message;
  int? fileId;
  String? fileTitle;
  String? fileAddress;
  int? consultantId;
  String? consultantName;
  String? consultantAvatar;

  ChatItem.fromJson(dynamic json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["file"] is List) {
      Map<String, dynamic> file = json["file"][0];

      fileId = file["id"];
      fileTitle = file["title"];
      fileAddress = file["address"];
    }
    if (json["consultant"] is List) {
      Map<String, dynamic> consultant = json["consultant"][0];

      consultantId = consultant["id"];
      consultantName = consultant["name"];
      consultantAvatar = consultant["avatar"];
    }
    if (json["message"] is Map) {
      message = json["message"] == null ? null : ChatLastMessage.fromJson(json["message"]);
    }
  }
}

class ChatLastMessage {
  int? id;
  int? countUnseen;
  String? timeAgo;
  String? type;
  dynamic message;
  bool? isConsultant;
  int? status;
  bool? deleteBySender;
  String? createDate;
  String? modifyDate;
  bool? isSeen;
  int? userId;
  int? chatId;
  dynamic replyId;
  int? consultantFileId;

  ChatLastMessage.fromJson(dynamic json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["countUnseen"] is int) {
      countUnseen = json["countUnseen"];
    }
    if (json["timeAgo"] is String) {
      timeAgo = json["timeAgo"];
    }
    if (json["type"] is String) {
      type = json["type"];
    }
    message = json["message"];
    if (json["isConsultant"] is bool) {
      isConsultant = json["isConsultant"];
    }
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["deleteBySender"] is bool) {
      deleteBySender = json["deleteBySender"];
    }
    if (json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if (json["modifyDate"] is String) {
      modifyDate = json["modifyDate"];
    }
    if (json["isSeen"] is bool) {
      isSeen = json["isSeen"];
    }
    if (json["user_id"] is int) {
      userId = json["user_id"];
    }
    if (json["chat_id"] is int) {
      chatId = json["chat_id"];
    }
    replyId = json["reply_id"];
    if (json["consultantFile_id"] is int) {
      consultantFileId = json["consultantFile_id"];
    }
  }
}
