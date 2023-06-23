
class ChatMessage {
  int? id;
  String? message;
  String? createDate;
  String? modifyDate;
  int? type;
  dynamic fileMessage;
  int? userId;
  dynamic replyId;
  int? chatId;
  bool? isConsultant;
  int? consultantFileId;
  String? timeAgo;

  ChatMessage({this.id, this.message, this.createDate, this.modifyDate, this.type, this.fileMessage, this.userId, this.replyId, this.chatId, this.isConsultant, this.consultantFileId, this.timeAgo});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if(json["modifyDate"] is String) {
      modifyDate = json["modifyDate"];
    }
    if(json["type"] is int) {
      type = json["type"];
    }
    fileMessage = json["fileMessage"];
    if(json["user_id"] is int) {
      userId = json["user_id"];
    }
    replyId = json["reply_id"];
    if(json["chat_id"] is int) {
      chatId = json["chat_id"];
    }
    if(json["isConsultant"] is bool) {
      isConsultant = json["isConsultant"];
    }
    if(json["consultantFile_id"] is int) {
      consultantFileId = json["consultantFile_id"];
    }
    if(json["timeAgo"] is String) {
      timeAgo = json["timeAgo"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["message"] = message;
    _data["createDate"] = createDate;
    _data["modifyDate"] = modifyDate;
    _data["type"] = type;
    _data["fileMessage"] = fileMessage;
    _data["user_id"] = userId;
    _data["reply_id"] = replyId;
    _data["chat_id"] = chatId;
    _data["isConsultant"] = isConsultant;
    _data["consultantFile_id"] = consultantFileId;
    _data["timeAgo"] = timeAgo;
    return _data;
  }
}