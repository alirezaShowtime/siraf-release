
class ConsultantInfo {
  int? id;
  String? name;
  String? avatar;
  dynamic rate;
  List<Comment>? comment;
  int? countConstruction;
  int? countRent;
  int? countOnSale;

  ConsultantInfo({this.id, this.name, this.avatar, this.rate, this.comment, this.countConstruction, this.countRent, this.countOnSale});

  ConsultantInfo.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["avatar"] is String) {
      avatar = json["avatar"];
    }
    rate = json["rate"];
    if(json["comment"] is List) {
      comment = json["comment"] == null ? null : (json["comment"] as List).map((e) => Comment.fromJson(e)).toList();
    }
    if(json["countConstruction"] is int) {
      countConstruction = json["countConstruction"];
    }
    if(json["countRent"] is int) {
      countRent = json["countRent"];
    }
    if(json["countOnSale"] is int) {
      countOnSale = json["countOnSale"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["avatar"] = avatar;
    _data["rate"] = rate;
    if(comment != null) {
      _data["comment"] = comment?.map((e) => e.toJson()).toList();
    }
    _data["countConstruction"] = countConstruction;
    _data["countRent"] = countRent;
    _data["countOnSale"] = countOnSale;
    return _data;
  }
}

class Comment {
  int? id;
  int? likeCount;
  int? countDisLike;
  String? comment;
  int? consultantId;
  UserId? userId;
  String? createDate;
  dynamic rate;

  Comment({this.id, this.likeCount, this.countDisLike, this.comment, this.consultantId, this.userId, this.createDate, this.rate});

  Comment.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["likeCount"] is int) {
      likeCount = json["likeCount"];
    }
    if(json["countDisLike"] is int) {
      countDisLike = json["countDisLike"];
    }
    if(json["comment"] is String) {
      comment = json["comment"];
    }
    if(json["consultant_id"] is int) {
      consultantId = json["consultant_id"];
    }
    if(json["user_id"] is Map) {
      userId = json["user_id"] == null ? null : UserId.fromJson(json["user_id"]);
    }
    if(json["createDate"] is String) {
      createDate = json["createDate"];
    }
    rate = json["rate"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["likeCount"] = likeCount;
    _data["countDisLike"] = countDisLike;
    _data["comment"] = comment;
    _data["consultant_id"] = consultantId;
    if(userId != null) {
      _data["user_id"] = userId?.toJson();
    }
    _data["createDate"] = createDate;
    _data["rate"] = rate;
    return _data;
  }
}

class UserId {
  int? id;
  String? name;
  String? avatar;

  UserId({this.id, this.name, this.avatar});

  UserId.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["avatar"] is String) {
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