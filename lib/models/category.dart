class Category {
  int? id;
  String? name;
  dynamic image;
  String? fullCategory;
  bool? isAll;
  dynamic parentId;

  Category(
      {this.id,
      this.name,
      this.image,
      this.fullCategory,
      this.isAll,
      this.parentId});

  Category.fromJson(Map<String, dynamic> json) {
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
    parentId = json["parent_id"];
  }

  static List<Category> fromList(List<dynamic> list) {
    var list2 = <Category>[];

    for (dynamic item in list) {
      list2.add(Category.fromJson(item));
    }

    return list2;
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

  int isAllInt() {
    return (isAll ?? false) ? 0 : 1;
  }
}
