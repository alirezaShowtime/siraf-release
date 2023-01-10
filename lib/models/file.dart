import 'package:siraf3/helpers.dart';

class File {
  int? id;
  String? name;
  String? description;
  List<Images>? images;
  bool? favorite;
  String? publishedAgo;
  List<Property>? propertys;
  FullCategory? fullCategory;
  String? city;

  File(
      {this.id,
      this.name,
      this.description,
      this.images,
      this.favorite,
      this.publishedAgo,
      this.propertys,
      this.fullCategory,
      this.city});

  File.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["images"] is List) {
      images = json["images"] == null
          ? null
          : (json["images"] as List).map((e) => Images.fromJson(e)).toList();
    }
    if (json["favorite"] is bool) {
      favorite = json["favorite"];
    }
    if (json["publishedAgo"] is String) {
      publishedAgo = json["publishedAgo"];
    }
    if (json["propertys"] is List) {
      propertys = json["propertys"] == null
          ? null
          : (json["propertys"] as List)
              .map((e) => Property.fromJson(e))
              .toList();
    }
    if (json["category"] is Map) {
      fullCategory = json["category"] == null
          ? null
          : FullCategory.fromJson(json["category"]);
    }
    if (json["city"] is String) {
      city = json["city"];
    }

    if (propertys != null) {
      propertys!.sort((a, b) => a.weightList!.compareTo(b.weightList!));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    if (images != null) {
      _data["images"] = images?.map((e) => e.toJson()).toList();
    }
    _data["favorite"] = favorite;
    _data["publishedAgo"] = publishedAgo;
    if (propertys != null) {
      _data["propertys"] = propertys?.map((e) => e.toJson()).toList();
    }
    if (fullCategory != null) {
      _data["category"] = fullCategory?.toJson();
    }
    _data["city"] = city;
    return _data;
  }

  static List<File> fromList(List<dynamic> list) {
    var list2 = <File>[];

    for (dynamic item in list) {
      list2.add(File.fromJson(item));
    }

    return list2;
  }

  String getFirstPrice() {
    if (propertys!.where((element) => element.weightList == 5).isNotEmpty) {
      var prop = propertys!.firstWhere((element) => element.weightList == 5);
      return number_format(int.parse(prop.value!)) + " " + prop.name!;
    } else {
      return "";
    }
  }

  String getSecondPrice() {
    if (propertys!.where((element) => element.weightList == 6).isNotEmpty) {
      var prop = propertys!.firstWhere((element) => element.weightList == 6);
      return number_format(int.parse(prop.value!)) + " " + prop.name!;
    } else {
      return "";
    }
  }
}

class FullCategory {
  int? id;
  String? name;
  dynamic image;
  String? fullCategory;
  bool? isAll;
  int? parentId;

  FullCategory(
      {this.id,
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

class Property {
  String? name;
  String? value;
  bool? list;
  int? weightList;

  Property({this.name, this.value, this.list, this.weightList});

  Property.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["value"] is int || json["value"] is String) {
      value = json["value"].toString();
    }
    if (json["list"] is bool) {
      list = json["list"];
    }
    if (json["weightList"] is int) {
      weightList = json["weightList"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["value"] = value;
    _data["list"] = list;
    _data["weightList"] = weightList;
    return _data;
  }
}

class Images {
  int? id;
  String? createDate;
  String? path;
  bool? status;
  int? weight;
  String? name;
  int? fileId;

  Images(
      {this.id,
      this.createDate,
      this.path,
      this.status,
      this.weight,
      this.name,
      this.fileId});

  Images.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if (json["path"] is String) {
      path = json["path"];
    }
    if (json["status"] is bool) {
      status = json["status"];
    }
    if (json["weight"] is int) {
      weight = json["weight"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["file_id"] is int) {
      fileId = json["file_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["createDate"] = createDate;
    _data["path"] = path;
    _data["status"] = status;
    _data["weight"] = weight;
    _data["name"] = name;
    _data["file_id"] = fileId;
    return _data;
  }
}
