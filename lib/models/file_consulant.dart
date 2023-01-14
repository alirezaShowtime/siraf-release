
class FileConsulant {
  int? id;
  ConsultantId? consultantId;
  String? createDate;
  bool? status;
  int? estateFileId;

  FileConsulant({this.id, this.consultantId, this.createDate, this.status, this.estateFileId});

  FileConsulant.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["consultant_id"] is Map) {
      consultantId = json["consultant_id"] == null ? null : ConsultantId.fromJson(json["consultant_id"]);
    }
    if(json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if(json["status"] is bool) {
      status = json["status"];
    }
    if(json["estateFile_id"] is int) {
      estateFileId = json["estateFile_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if(consultantId != null) {
      _data["consultant_id"] = consultantId?.toJson();
    }
    _data["createDate"] = createDate;
    _data["status"] = status;
    _data["estateFile_id"] = estateFileId;
    return _data;
  }

  
  static List<FileConsulant> fromList(List<dynamic> list) {
    var list2 = <FileConsulant>[];

    for (dynamic item in list) {
      list2.add(FileConsulant.fromJson(item));
    }

    return list2;
  }

}

class ConsultantId {
  int? id;
  String? name;
  String? phone;
  String? avatar;

  ConsultantId({this.id, this.name, this.phone, this.avatar});

  ConsultantId.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["phone"] is String) {
      phone = json["phone"];
    }
    if(json["avatar"] is String) {
      avatar = json["avatar"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["phone"] = phone;
    _data["avatar"] = avatar;
    return _data;
  }
}