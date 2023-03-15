
class RequestConsultant {
  int? estateRequestFileId;
  String? estateName;
  String? estateId;
  ConsultantId? consultantId;

  RequestConsultant({this.estateRequestFileId, this.estateName, this.estateId, this.consultantId});

  RequestConsultant.fromJson(Map<String, dynamic> json) {
    if(json["estateRequestFile_id"] is int) {
      estateRequestFileId = json["estateRequestFile_id"];
    }
    if(json["estateName"] is String) {
      estateName = json["estateName"];
    }
    if(json["estateId"] is String) {
      estateId = json["estateId"];
    }
    if(json["consultant_id"] is Map) {
      consultantId = json["consultant_id"] == null ? null : ConsultantId.fromJson(json["consultant_id"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["estateRequestFile_id"] = estateRequestFileId;
    _data["estateName"] = estateName;
    _data["estateId"] = estateId;
    if(consultantId != null) {
      _data["consultant_id"] = consultantId?.toJson();
    }
    return _data;
  }

  static List<RequestConsultant> fromList(List<dynamic> list) {
    var list2 = <RequestConsultant>[];

    for (dynamic item in list) {
      list2.add(RequestConsultant.fromJson(item));
    }

    return list2;
  }
}

class ConsultantId {
  int? id;
  String? avatar;
  String? name;
  int? status;
  int? rate;

  ConsultantId({this.id, this.avatar, this.name, this.status, this.rate});

  ConsultantId.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["avatar"] is String) {
      avatar = json["avatar"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["status"] is int) {
      status = json["status"];
    }
    if(json["rate"] is int) {
      rate = json["rate"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["avatar"] = avatar;
    _data["name"] = name;
    _data["status"] = status;
    _data["rate"] = rate;
    return _data;
  }
}