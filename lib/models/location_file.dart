import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/city.dart';

class LocationFile {
  int? id;
  String? name;
  Category? category;
  String? lat;
  String? long;
  List<Image>? images;
  Image? image;
  List<Propertys>? propertys;
  bool? favorite;
  String? lat_long;
  String? publishedAgo;
  City? city;

  LocationFile({
    this.id,
    this.name,
    this.category,
    this.lat,
    this.long,
    this.images,
    this.image,
    this.propertys,
    this.favorite,
    this.publishedAgo,
    this.city,
  });

  LocationFile.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["category"] is Map) {
      category = json["category"] == null ? null : Category.fromJson(json["category"]);
    }
    if (json["lat"] is String) {
      lat = json["lat"];
    }
    if (json["long"] is String) {
      long = json["long"];
    }
    if (json["image"] is Map) {
      image = json["image"] == null ? null : Image.fromJson(json["image"]);
    }
    if (json["images"] is List) {
      images = json["images"] == null
          ? null
          : (json["images"] as List)
              .map((e) => Image.fromJson(e))
              .where(
                (element) => element.name != null,
              )
              .toList();

      if (images.isFill()) {
        image = images!.first;
      }
    }
    if (json["propertys"] is List) {
      propertys = json["propertys"] == null
          ? null
          : (json["propertys"] as List)
              .map((e) => Propertys.fromJson(e))
              .where(
                (element) => element.name != null,
              )
              .toList();
    }
    if (json["favorite"] is bool) {
      favorite = json["favorite"];
    }
    if (json["publishedAgo"] is String) {
      publishedAgo = json["publishedAgo"];
    }
    if (json['city'] is Map) {
      city = json['city'] == null ? null : City.fromJson(json['city']);
    }

    lat_long = lat.toString() + "," + long.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    if (category != null) {
      _data["category"] = category?.toJson();
    }
    _data["lat"] = lat;
    _data["long"] = long;
    if (image != null) {
      _data["image"] = image?.toJson();
    }
    if (propertys != null) {
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


  String getPricePerMeter() {
    if ((getFirstPriceInt() == -1 || getFirstPriceInt() == 0) || getMeter() == 0) {
      return "";
    }
    var result = getFirstPriceInt() ~/ getMeter();

    if (result == 0) {
      return "";
    }

    var rounded_result = (result / 100000).round() * 100000;

    if (rounded_result != 0) result = rounded_result;

    return "قیمت هر متر " + number_format(result);
  }

  int getPricePerMeterInt() {
    if ((getFirstPriceInt() == -1 || getFirstPriceInt() == 0) || getMeter() == 0) {
      return -1;
    }
    var result = getFirstPriceInt() ~/ getMeter();

    if (result == 0) {
      return -1;
    }

    result = (result / 100000).round() * 100000;

    return result;
  }

  int getMeter() {
    if (propertys!.where((element) => element.weightList == 1).isNotEmpty) {
      var prop = propertys!.firstWhere((element) => element.weightList == 1);

      if (prop.value == null || prop.name == null) return 0;

      return int.parse(prop.value!);
    } else {
      return 0;
    }
  }

  int getFirstPriceInt() {
    if (propertys!.where((element) => element.weightList == 5).isNotEmpty) {
      var prop = propertys!.firstWhere((element) => element.weightList == 5);

      if (prop.value == null || prop.name == null) return -1;

      return int.parse(prop.value!);
    } else {
      return -1;
    }
  }

  int getSecondPriceInt() {
    if (propertys!.where((element) => element.weightList == 6).isNotEmpty) {
      var prop = propertys!.firstWhere((element) => element.weightList == 6);

      if (prop.value == null || prop.name == null) return -1;

      return int.parse(prop.value!);
    } else {
      return -1;
    }
  }

  String getFirstPrice() {
    if (propertys!.where((element) => element.weightList == 5).isNotEmpty) {
      var prop = propertys!.firstWhere((element) => element.weightList == 5);

      if (prop.value == null || prop.name == null) return adaptivePrice(prop.value, name: prop.name);

      return toPrice(prop.value!, prop.name!);
    } else {
      var name = "";
      if (isRent()) name = "ودیعه";
      if (category?.name?.contains("روزانه") ?? false) name = "اجاره روزانه";

      return adaptivePrice("", name: name);
    }
  }

  String getSecondPrice() {
    if (!isRent()) return getPricePerMeter();

    if (propertys!.where((element) => element.weightList == 6).isNotEmpty) {
      var prop = propertys!.firstWhere((element) => element.weightList == 6);

      if (prop.value == null || prop.name == null) return adaptivePrice(prop.value, name: prop.name);

      return toPrice(prop.value!, prop.name!);
    } else {
      if (category?.name?.contains("روزانه") ?? false) return "";

      return adaptivePrice("", name: "اجاره");
    }
  }

  String adaptivePrice(value, {String? name}) {
    if (value.toString() == "0") {
      return "رایگان";
    }
    return (name != null ? "$name " : "") + "توافقی";
  }

  String toPrice(dynamic value, String name) {
    if (value.toString() == "0") {
      return "$name رایگان";
    }

    var v = int.parse(value.toString());

    return "$name ${number_format(v)}";
  }

  // String getPricePerMeter() {
  //   if ((getFirstPriceInt() == -1 || getFirstPriceInt() == 0) || getMeter() == 0) {
  //     return "توافقی";
  //   }
  //   var result = getFirstPriceInt() ~/ getMeter();
  //
  //   if (result == 0) {
  //     return "توافقی";
  //   }
  //
  //   result = (result / 100000).round() * 100000;
  //
  //   return "قیمت هر متر " + number_format(result);
  // }
  //
  // int getPricePerMeterInt() {
  //   if ((getFirstPriceInt() == -1 || getFirstPriceInt() == 0) || getMeter() == 0) {
  //     return -1;
  //   }
  //   var result = getFirstPriceInt() ~/ getMeter();
  //
  //   if (result == 0) {
  //     return -1;
  //   }
  //
  //   result = (result / 100000).round() * 100000;
  //
  //   return result;
  // }
  //
  // int getMeter() {
  //   if (propertys!.where((element) => element.weightList == 1).isNotEmpty) {
  //     var prop = propertys!.firstWhere((element) => element.weightList == 1);
  //
  //     if (prop.value == null || prop.name == null) return 0;
  //
  //     return int.parse(prop.value!);
  //   } else {
  //     return 0;
  //   }
  // }
  //
  // int getFirstPriceInt() {
  //   if (propertys!.where((element) => element.weightList == 5).isNotEmpty) {
  //     var prop = propertys!.firstWhere((element) => element.weightList == 5);
  //
  //     if (prop.value == null || prop.name == null) return -1;
  //
  //     return int.parse(prop.value!);
  //   } else {
  //     return -1;
  //   }
  // }
  //
  // int getSecondPriceInt() {
  //   if (propertys!.where((element) => element.weightList == 6).isNotEmpty) {
  //     var prop = propertys!.firstWhere((element) => element.weightList == 6);
  //
  //     if (prop.value == null || prop.name == null) return -1;
  //
  //     return int.parse(prop.value!);
  //   } else {
  //     return -1;
  //   }
  // }
  //
  // String getFirstPrice() {
  //   if (propertys!.where((element) => element.weightList == 5).isNotEmpty) {
  //     var prop = propertys!.firstWhere((element) => element.weightList == 5);
  //
  //     if (prop.value == null || prop.name == null) return adaptivePrice(prop.value, name: prop.name);
  //
  //     if (isRent()) return toPrice(prop.value!, prop.name!);
  //     return number_format(prop.value!) + " تومان";
  //   } else {
  //     return adaptivePrice("");
  //   }
  // }
  //
  // String getSecondPrice() {
  //   if (!isRent()) {
  //     return getPricePerMeter();
  //   }
  //   if (fullAdaptive()) return "";
  //
  //   if (propertys!.where((element) => element.weightList == 6).isNotEmpty) {
  //     var prop = propertys!.firstWhere((element) => element.weightList == 6);
  //
  //     if (prop.value == null || prop.name == null) return adaptivePrice(prop.value, name: prop.name);
  //
  //     return toPrice(prop.value!, prop.name!);
  //   } else {
  //     return adaptivePrice("");
  //   }
  // }
  //
  // String adaptivePrice(value, {String? name}) {
  //   if (value.toString() == "0") {
  //     return name != null ? "$name : رایگان" : "رایگان";
  //   }
  //   return (name != null && !fullAdaptive() ? "$name توافقی" : "") + "توافقی";
  // }
  //
  // String toPrice(dynamic value, String name) {
  //   if (value.toString() == "0") {
  //     return "$name : رایگان";
  //   }
  //
  //   return "$name : ${number_format(value)}";
  // }

  bool fullAdaptive() {
    return (getFirstPriceInt() == -1 && getSecondPriceInt() == -1);
  }

  bool isRent() => category?.fullCategory?.contains("اجاره") ?? false;
}

class Propertys {
  String? name;
  String? value;
  bool? list;
  int? weightList;

  Propertys({this.name, this.value, this.list, this.weightList});

  Propertys.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["value"] is int || json["value"] is double || json["value"] is String) {
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

class Category {
  int? id;
  String? name;
  dynamic image;
  String? fullCategory;
  bool? isAll;
  int? parentId;

  Category({this.id, this.name, this.image, this.fullCategory, this.isAll, this.parentId});

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
    return fullCategory != null ? fullCategory!.split("-")[0].trim() : null;
  }
}
