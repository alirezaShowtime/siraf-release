class Ticket {
  int? id;
  String? title;
  bool status = true;
  String? lastMessage;
  String? lastMessageCreateDate;
  String? lastMessageCreateTime;
  String? groupName;
  String? timeAgo;
  String? statusMessage;
  TicketSender? ticketSender;

  Ticket(
      {this.id, this.title, this.status = true, this.lastMessage, this.lastMessageCreateDate, this.groupName, this.statusMessage, this.timeAgo});

  Ticket.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["timeAgo"] is String) {
      timeAgo = json["timeAgo"];
    }
    if (json["status"] is int) {
      status = json["status"] == 1 ? true : false;
    }
    if (json["status"] is bool) {
      status = json["status"];
    }
    if (json["lastMessage"] is String) {
      lastMessage = json["lastMessage"];
    }
    if (json["lastMessageCreateTime"] is String) {
      lastMessageCreateTime = json["lastMessageCreateTime"];
    }
    if (json["lastMessageCreateDate"] is String) {
      lastMessageCreateDate = json["lastMessageCreateDate"];
    }
    if (json["groupName"] is String) {
      groupName = json["groupName"];
    }
    if (json["statusMessage"] is String) {
      statusMessage = json["statusMessage"];
    }
    if (json["sender_id"] is Map) {
      ticketSender = TicketSender.fromJson(json["sender_id"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["title"] = title;
    _data["status"] = status;
    _data["timeAgo"] = timeAgo;
    _data["lastMessage"] = lastMessage;
    _data["lastMessageCreateDate"] = lastMessageCreateDate;
    _data["lastMessageCreateTime"] = lastMessageCreateTime;
    _data["groupName"] = groupName;
    _data["statusMessage"] = statusMessage;
    return _data;
  }

  static List<Ticket> fromList(List<dynamic> list) {
    var list2 = <Ticket>[];

    for (dynamic item in list) {
      list2.add(Ticket.fromJson(item));
    }

    return list2;
  }
}

class TicketSender {
  String? name;
  String? avatar;
  int? id;

  TicketSender({this.id, this.name, this.avatar});

  TicketSender.fromJson(dynamic data) {
    if (data["id"] is int) {
      id = data["id"];
    }

    if (data["name"] is String) {
      name = data["name"];
    }

    if (data["avatar"] is String) {
      avatar = data["avatar"];
    }
  }
}
