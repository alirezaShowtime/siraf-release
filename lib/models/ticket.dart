
class Ticket {
  int? id;
  String? title;
  int? status;
  String? lastMessage;
  String? lastMessageCreateDate;
  String? groupName;
  bool? statusMessage;

  Ticket({this.id, this.title, this.status, this.lastMessage, this.lastMessageCreateDate, this.groupName, this.statusMessage});

  Ticket.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["title"] is String) {
      title = json["title"];
    }
    if(json["status"] is int) {
      status = json["status"];
    }
    if(json["lastMessage"] is String) {
      lastMessage = json["lastMessage"];
    }
    if(json["lastMessageCreateDate"] is String) {
      lastMessageCreateDate = json["lastMessageCreateDate"];
    }
    if(json["groupName"] is String) {
      groupName = json["groupName"];
    }
    if(json["statusMessage"] is bool) {
      statusMessage = json["statusMessage"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["title"] = title;
    _data["status"] = status;
    _data["lastMessage"] = lastMessage;
    _data["lastMessageCreateDate"] = lastMessageCreateDate;
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