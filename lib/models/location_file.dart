
import 'package:siraf3/helpers.dart';

class LocationFile {
  int? id;
  String? name;
  Category? category;
  String? lat;
  String? long;
  Image? image;
  List<Propertys>? propertys;
  bool? favorite;
  String? lat_long;

  LocationFile({this.id, this.name, this.category, this.lat, this.long, this.image, this.propertys, this.favorite});

  LocationFile.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["category"] is Map) {
      category = json["category"] == null ? null : Category.fromJson(json["category"]);
    }
    if(json["lat"] is String) {
      lat = json["lat"];
    }
    if(json["long"] is String) {
      long = json["long"];
    }
    if(json["image"] is Map) {
      image = json["image"] == null ? null : Image.fromJson(json["image"]);
    }
    if(json["propertys"] is List) {
      propertys = json["propertys"] == null ? null : (json["propertys"] as List).map((e) => Propertys.fromJson(e)).toList();
    }
    if(json["favorite"] is bool) {
      favorite = json["favorite"];
    }

    lat_long = lat.toString() + "," + long.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    if(category != null) {
      _data["category"] = category?.toJson();
    }
    _data["lat"] = lat;
    _data["long"] = long;
    if(image != null) {
      _data["image"] = image?.toJson();
    }
    if(propertys != null) {
      _data["propertys"] = propertys?.map((e) => e.toJson()).toList();
    }
    _data["favorite"] = favorite;
    return _data;
  }


  static List<LocationFile> fromList(List<dynamic> list) {
    var list2 = <LocationFile>[];

    for (dynamic item in list) {
      list2.add(LocationFile.fromJson(item));
    }

    return list2;
  }


  String getFirstPrice() {
    if (propertys!.where((element) => element.weightList == 5).isNotEmpty) {
      var prop = propertys!.firstWhere((element) => element.weightList == 5);

      if (prop.value == null || prop.name == null) return "توافقی";

      return number_format(int.parse(prop.value!));
    } else {
      return "توافقی";
    }
  }

  String getSecondPrice() {
    if (propertys!.where((element) => element.weightList == 6).isNotEmpty) {
      var prop = propertys!.firstWhere((element) => element.weightList == 6);

      if (prop.value == null || prop.name == null) return "توافقی";

      return number_format(int.parse(prop.value!));
    } else {
      return "توافقی";
    }
  }

  bool isRent() {
    return category?.getMainCategoryName() == "اجاره ای";
  }
}

class Propertys {
  String? name;
  String? value;
  bool? list;
  int? weightList;

  Propertys({this.name, this.value, this.list, this.weightList});

  Propertys.fromJson(Map<String, dynamic> json) {
    if(json["name"] is String) {
      name = json["name"];
    }
    if (json["value"] is int || json["value"] is double || json["value"] is String) {
      value = json["value"].toString();
    }
    if(json["list"] is bool) {
      list = json["list"];
    }
    if(json["weightList"] is int) {
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

class Image {
  int? id;
  String? createDate;
  String? path;
  bool? status;
  int? weight;
  String? name;
  int? fileId;

  Image({this.id, this.createDate, this.path, this.status, this.weight, this.name, this.fileId});

  Image.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if(json["path"] is String) {
      path = json["path"];
    }
    if(json["status"] is bool) {
      status = json["status"];
    }
    if(json["weight"] is int) {
      weight = json["weight"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["file_id"] is int) {
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

class Category {
  int? id;
  String? name;
  dynamic image;
  String? fullCategory;
  bool? isAll;
  int? parentId;

  Category({this.id, this.name, this.image, this.fullCategory, this.isAll, this.parentId});

  Category.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    image = json["image"];
    if(json["fullCategory"] is String) {
      fullCategory = json["fullCategory"];
    }
    if(json["isAll"] is bool) {
      isAll = json["isAll"];
    }
    if(json["parent_id"] is int) {
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
    return fullCategory != null ? fullCategory!.split("-")[0].trim() : null;
  }
}