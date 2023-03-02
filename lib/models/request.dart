class Request {
  int? id;
  FullCategory? categoryId;
  int? cityId;
  int? minPrice;
  int? maxPrice;
  String? title;
  int? maxMeter;
  int? minMeter;
  String? status;
  String? description;
  int? userId;
  String? createDate;

  Request({this.id, this.categoryId, this.cityId, this.minPrice, this.maxPrice, this.title, this.maxMeter, this.minMeter, this.status, this.description, this.userId, this.createDate});

  Request.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["category_id"] != null) {
      categoryId = FullCategory.fromJson(json["category_id"]);
    }
    if (json["city_id"] is int) {
      cityId = json["city_id"];
    }
    if (json["minPrice"] is int) {
      minPrice = json["minPrice"];
    }
    if (json["maxPrice"] is int) {
      maxPrice = json["maxPrice"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["maxMeter"] is int) {
      maxMeter = json["maxMeter"];
    }
    if (json["minMeter"] is int) {
      minMeter = json["minMeter"];
    }
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["user_id"] is int) {
      userId = json["user_id"];
    }
    if (json["createDate"] is String) {
      createDate = json["createDate"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["category_id"] = categoryId;
    _data["city_id"] = cityId;
    _data["minPrice"] = minPrice;
    _data["maxPrice"] = maxPrice;
    _data["title"] = title;
    _data["maxMeter"] = maxMeter;
    _data["minMeter"] = minMeter;
    _data["status"] = status;
    _data["description"] = description;
    _data["user_id"] = userId;
    return _data;
  }


  static List<Request> fromList(List<dynamic> list) {
    var list2 = <Request>[];

    for (dynamic item in list) {
      list2.add(Request.fromJson(item));
    }

    return list2;
  }
}


class FullCategory {
  int? id;
  String? name;
  dynamic image;
  String? fullCategory;
  bool? isAll;
  int? parentId;

  FullCategory({this.id,
    this.name,
    this.image,
    this.fullCategory,
    this.isAll,
    this.parentId});

  FullCategory.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    image = json["image"];
    if (json["fullCategory"] is String) {
      fullCategory = json["fullCategory"];
    }
    if (json["isAll"] is bool) {
      isAll = json["isAll"];
    }
    if (json["parent_id"] is int) {
      parentId = json["parent_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["image"] = image;
    _data["fullCategory"] = fullCategory;
    _data["isAll"] = isAll;
    _data["parent_id"] = parentId;
    return _data;
  }

  String? getMainCategoryName() {
    return fullCategory != null ? fullCategory!.split("-")[0] : null;
  }
}