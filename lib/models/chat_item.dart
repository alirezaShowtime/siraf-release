class ChatItem {
  int? countNotSeen;
  String? timeAgo;
  String? type;
  dynamic message;
  bool? isConsultant;
  bool isBlockByMe = false;
  bool isBlockByHer = false;
  bool isDeleted = false;
  bool deleteBySender = false;
  int? status;
  String? createDate;
  String? modifyDate;
  String? lastMessage;
  String? createTime;
  int? consultantId;
  String? consultantName;
  String? consultantAvatar;
  bool? isSeen;
  int? userId;
  int? id;
  int? fileId;
  String? fileTitle;
  String? fileAddress;
  String? fileImage;
  dynamic replyId;
  int? consultantFileId;

  ChatItem.fromJson(dynamic json) {
    if (json["id"] is int) {
      id = json["id"];
    }

    if (json["file"] is Map) {
      if (json["file"]["id"] is int) {
        fileId = json["file"]["id"];
      }
      if (json["file"]["name"] is String) {
        fileTitle = json["file"]["name"];
      }
      if (json["file"]["address"] is String) {
        fileAddress = json["file"]["address"];
      }
      if (json["file"]["image"] is String) {
        fileImage = json["file"]["image"];
      }
    }

    if (json["message"] is Map) {
      if (json["message"]["countNotSeen"] is int) {
        countNotSeen = json["message"]["countNotSeen"];
      }
      if (json["message"]["createDate"] is String) {
        createDate = json["message"]["createDate"];
      }
      if (json["message"]["createTime"] is String) {
        createTime = json["message"]["createTime"];
      }
      if (json["message"]["lastMessage"] is String) {
        lastMessage = json["message"]["lastMessage"];
      }
      if (json["message"]["isSeen"] is bool) {
        isSeen = json["message"]["isSeen"];
      }
      if (json["message"]["isConsultant"] is bool) {
        isConsultant = json["message"]["isConsultant"];
      }
    }

    if (json["consultant"] is Map) {
      if (json["consultant"]["id"] is int) {
        consultantId = json["consultant"]["id"];
      }
      if (json["consultant"]["name"] is String) {
        consultantName = json["consultant"]["name"];
      }
      if (json["consultant"]["avatar"] is String) {
        consultantAvatar = json["consultant"]["avatar"];
      }
    }
    if (json["disableBySender"] is bool) {
      isBlockByMe = json["disableBySender"];
    }
    if (json["deleteBySender"] is bool) {
      deleteBySender = json["deleteBySender"];
    }
    if (json["disableByConsultant"] is bool) {
      isBlockByHer = json["disableByConsultant"];
    }
    if (json["deleteByConsultant"] is bool) {
      isDeleted = json["deleteByConsultant"];
    }
  }
}
