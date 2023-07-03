
class Post {
  int? id;
  int? isBookmark;
  String? coverImage;
  List<Tag>? tag;
  List<Videos>? videos;
  List<Images>? images;
  String? title;
  String? description;
  int? type;
  String? createAt;
  String? modifyAt;
  int? creator;
  int? modifier;

  Post({this.id, this.isBookmark, this.coverImage, this.tag, this.videos, this.images, this.title, this.description, this.type, this.createAt, this.modifyAt, this.creator, this.modifier});

  Post.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["isBookmark"] is int) {
      isBookmark = json["isBookmark"];
    }
    if(json["coverImage"] is String) {
      coverImage = json["coverImage"];
    }
    if(json["tag"] is List) {
      tag = json["tag"] == null ? null : (json["tag"] as List).map((e) => Tag.fromJson(e)).toList();
    }
    if(json["videos"] is List) {
      videos = json["videos"] == null ? null : (json["videos"] as List).map((e) => Videos.fromJson(e)).toList();
    }
    if(json["images"] is List) {
      images = json["images"] == null ? null : (json["images"] as List).map((e) => Images.fromJson(e)).toList();
    }
    if(json["title"] is String) {
      title = json["title"];
    }
    if(json["description"] is String) {
      description = json["description"];
    }
    if(json["type"] is int) {
      type = json["type"];
    }
    if(json["createAt"] is String) {
      createAt = json["createAt"];
    }
    if(json["modifyAt"] is String) {
      modifyAt = json["modifyAt"];
    }
    if(json["creator"] is int) {
      creator = json["creator"];
    }
    if(json["modifier"] is int) {
      modifier = json["modifier"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["isBookmark"] = isBookmark;
    _data["coverImage"] = coverImage;
    if(tag != null) {
      _data["tag"] = tag?.map((e) => e.toJson()).toList();
    }
    if(videos != null) {
      _data["videos"] = videos?.map((e) => e.toJson()).toList();
    }
    if(images != null) {
      _data["images"] = images?.map((e) => e.toJson()).toList();
    }
    _data["title"] = title;
    _data["description"] = description;
    _data["type"] = type;
    _data["createAt"] = createAt;
    _data["modifyAt"] = modifyAt;
    _data["creator"] = creator;
    _data["modifier"] = modifier;
    return _data;
  }

  
  static List<Post> fromList(List<dynamic> list) {
    var list2 = <Post>[];

    for (dynamic item in list) {
      list2.add(Post.fromJson(item));
    }

    return list2;
  }
}

class Images {
  String? path;

  Images({this.path});

  Images.fromJson(Map<String, dynamic> json) {
    if(json["path"] is String) {
      path = json["path"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["path"] = path;
    return _data;
  }
}

class Videos {
  String? path;

  Videos({this.path});

  Videos.fromJson(Map<String, dynamic> json) {
    if(json["path"] is String) {
      path = json["path"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["path"] = path;
    return _data;
  }
}

class Tag {
  int? tagId;

  Tag({this.tagId});

  Tag.fromJson(Map<String, dynamic> json) {
    if(json["tag_id"] is int) {
      tagId = json["tag_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["tag_id"] = tagId;
    return _data;
  }
}