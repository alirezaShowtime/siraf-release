import 'package:siraf3/enums/message_owner.dart';

class TicketDetails {
  int? id;
  String? title;
  GroupId? groupId;
  SenderId? senderId;
  List<Message>? messages;
  bool? status;

  TicketDetails({this.id, this.title, this.groupId, this.senderId, this.messages, this.status});

  TicketDetails.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["group_id"] is Map) {
      groupId = json["group_id"] == null ? null : GroupId.fromJson(json["group_id"]);
    }
    if (json["sender_id"] is Map) {
      senderId = json["sender_id"] == null ? null : SenderId.fromJson(json["sender_id"]);
    }
    if (json["Message"] is List) {
      messages = json["Message"] == null ? null : (json["Message"] as List).map((e) => Message.fromJson(e)).toList();
    }
    if (json["status"] is bool) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["title"] = title;
    if (groupId != null) {
      _data["group_id"] = groupId?.toJson();
    }
    if (senderId != null) {
      _data["sender_id"] = senderId?.toJson();
    }
    if (messages != null) {
      _data["Message"] = messages?.map((e) => e.toJson()).toList();
    }
    _data["status"] = status;
    return _data;
  }
}

class Message {
  int? id;
  String? createDate;
  String? createTime;
  int? expertId;
  String? message;
  String? expertName;
  String? expertAvatar;
  List<FileMessage>? fileMessage;

  Message({
    this.id,
    this.createDate,
    this.expertId,
    this.message,
    this.expertName,
    this.expertAvatar,
    this.fileMessage,
    this.createTime,
  });

  Message.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["expert_id"] is int) {
      expertId = json["expert_id"];
    }
    if (json["expertName"] is String) {
      expertName = json["expertName"];
    }
    if (json["expertAvatar"] is String) {
      expertAvatar = json["expertAvatar"];
    }
    if (json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if (json["createTime"] is String) {
      createTime = json["createTime"];
    }
    if (json["message"] is String) {
      message = json["message"];
    }
    if (json['fileMessage'] is List) {
      fileMessage = FileMessage.fromList(json["fileMessage"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["createDate"] = createDate;
    _data["expert_id"] = expertId;
    _data["message"] = message;
    _data["expertName"] = expertName;
    _data["expertAvatar"] = expertAvatar;
    _data["fileMessage"] = fileMessage;
    return _data;
  }

  MessageOwner get owner => expertId == null ? MessageOwner.ForME : MessageOwner.ForHer;
}

class SenderId {
  int? id;
  String? name;
  String? avatar;

  SenderId({this.id, this.name, this.avatar});

  SenderId.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["avatar"] is String) {
      avatar = json["avatar"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["avatar"] = avatar;
    return _data;
  }
}

class GroupId {
  int? id;
  String? name;

  GroupId({this.id, this.name});

  GroupId.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }
}

class FileMessage {
  int? id;
  String? path;
  String? createDate;
  int? messageId;
  String? fileSize;
  String? originName;

  String get name => Uri.decodeFull(this.path!).replaceAll("\\", "/").split("/").last;

  String get extension => this.path!.split(".").last;

  FileMessage({this.id, this.path, this.createDate, this.messageId, this.originName});

  FileMessage.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["path"] is String) {
      path = json["path"];
    }
    if (json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if (json["message_id"] is int) {
      messageId = json["message_id"];
    }
    if (json["fileSize"] is String) {
      fileSize = json["fileSize"];
    }
    if (json["fileName"] is int) {
      originName = json["fileName"] + "." + extension;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["path"] = path;
    _data["createDate"] = createDate;
    _data["message_id"] = messageId;
    return _data;
  }

  String? get getFileName {
    if (path == null) return null;

    return path!.split('/').last;
  }

  static List<FileMessage> fromList(List<dynamic> list) {
    var list2 = <FileMessage>[];

    for (dynamic item in list) {
      list2.add(FileMessage.fromJson(item));
    }

    return list2;
  }
}
