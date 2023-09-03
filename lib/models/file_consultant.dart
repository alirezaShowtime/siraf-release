class FileConsultant {
  int? id;
  ConsultantId? consultantId;
  String? estateName;
  String? createDate;
  bool? status;
  int? estateFileId;

  FileConsultant({this.id, this.consultantId, this.estateName, this.createDate, this.status, this.estateFileId});

  FileConsultant.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["consultant_id"] is Map) {
      consultantId = json["consultant_id"] == null ? null : ConsultantId.fromJson(json["consultant_id"]);
    }
    if (json["estateName"] is String) {
      estateName = json["estateName"];
    }
    if (json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if (json["status"] is bool) {
      status = json["status"];
    }
    if (json["estateFile_id"] is int) {
      estateFileId = json["estateFile_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if (consultantId != null) {
      _data["consultant_id"] = consultantId?.toJson();
    }
    _data["estateName"] = estateName;
    _data["createDate"] = createDate;
    _data["status"] = status;
    _data["estateFile_id"] = estateFileId;
    return _data;
  }

  static List<FileConsultant> fromList(List<dynamic> list) {
    var list2 = <FileConsultant>[];

    for (dynamic item in list) {
      list2.add(FileConsultant.fromJson(item));
    }

    return list2;
  }
}

class ConsultantId {
  int? id;
  String? name;
  String? phone;
  String? avatar;
  double? rate;

  ConsultantId({this.id, this.name, this.phone, this.avatar, this.rate});

  ConsultantId.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["phone"] is String) {
      phone = json["phone"];
    }
    if (json["avatar"] is String) {
      avatar = json["avatar"];
    }
    if (json["rate"] is double) {
      rate = json["rate"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["phone"] = phone;
    _data["avatar"] = avatar;
    _data["rate"] = rate;
    return _data;
  }
}
