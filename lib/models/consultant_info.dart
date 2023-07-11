class ConsultantInfo {
  int? id;
  String? name;
  String? avatar;
  dynamic rate;
  List<Comment>? comments;
  int? countConstruction;
  int? countRent;
  int? countOnSale;
  int? cityId;
  String? shareLink;
  String? bio;

  ConsultantInfo({this.id, this.name, this.avatar, this.rate, this.comments, this.countConstruction, this.countRent, this.countOnSale});

  ConsultantInfo.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["avatar"] is String) {
      avatar = json["avatar"];
    }
    rate = json["rate"];
    if (json["comments"] is List) {
      comments = json["comments"] == null ? null : (json["comments"] as List).map((e) => Comment.fromJson(e)).toList();
    }
    if (json["countConstruction"] is int) {
      countConstruction = json["countConstruction"];
    }
    if (json["countRent"] is int) {
      countRent = json["countRent"];
    }
    if (json["countOnSale"] is int) {
      countOnSale = json["countOnSale"];
    }
    if (json["city_id"] is int) {
      cityId = json["city_id"];
    }
    if (json["shareLink"] is String) {
      shareLink = json["shareLink"];
    }
    if (json["bio"] is String) {
      bio = json["bio"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["avatar"] = avatar;
    _data["rate"] = rate;
    if (comments != null) {
      _data["comment"] = comments?.map((e) => e.toJson()).toList();
    }
    _data["countConstruction"] = countConstruction;
    _data["countRent"] = countRent;
    _data["countOnSale"] = countOnSale;
    _data["shareLink"] = shareLink;
    _data["bio"] = bio;
    return _data;
  }
}

class Comment {
  int? id;
  int? likeCount;
  int? dislikeCount;
  String? comment;
  int? consultantId;
  UserId? userId;
  String? createDate;
  double rate = 0.0;
  List<ReplyComment>? replies;

  Comment.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["likeCount"] is int) {
      likeCount = json["likeCount"];
    }
    if (json["countDisLike"] is int) {
      dislikeCount = json["countDisLike"];
    }
    if (json["comment"] is String) {
      comment = json["comment"];
    }
    if (json["consultant_id"] is int) {
      consultantId = json["consultant_id"];
    }

    if (json["reply_id"] is List) {
      replies = (json["reply_id"] as List).map((e) => ReplyComment.fromJson(e)).toList();
    }

    if (json["user_id"] is Map) {
      userId = json["user_id"] == null ? null : UserId.fromJson(json["user_id"]);
    }
    if (json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if (json['rate'] is int || json['rate'] is double) {
      rate = double.parse(json["rate"].toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["likeCount"] = likeCount;
    _data["countDisLike"] = dislikeCount;
    _data["comment"] = comment;
    _data["consultant_id"] = consultantId;
    if (userId != null) {
      _data["user_id"] = userId?.toJson();
    }
    _data["createDate"] = createDate;
    _data["rate"] = rate;
    return _data;
  }
}

class ReplyComment {
  int? id;
  String? comment;
  String? createDate;
  String? name;
  String? avatar;

  ReplyComment.fromJson(dynamic json) {
    if (json['id'] is int) {
      id = json['id'];
    }
    if (json['comment'] is String) {
      comment = json['comment'];
    }
    if (json['createDate'] is String) {
      createDate = json['createDate'];
    }
    if (json['name'] is String) {
      name = json['name'];
    }
    if (json['avatar'] is String) {
      avatar = json['avatar'];
    }
  }
}

class UserId {
  int? id;
  String? name;
  String? avatar;

  UserId({this.id, this.name, this.avatar});

  UserId.fromJson(Map<String, dynamic> json) {
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
