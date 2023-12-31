import 'package:siraf3/helpers.dart';

class Note {
  int? id;
  FileId? fileId;
  String? note;
  String? createDate;
  String? modifyDate;
  int? creatorId;

  Note({this.id, this.fileId, this.note, this.createDate, this.modifyDate, this.creatorId});

  Note.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["file_id"] is Map) {
      fileId = json["file_id"] == null ? null : FileId.fromJson(json["file_id"]);
    }
    if (json["note"] is String) {
      note = json["note"];
    }
    if (json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if (json["modifyDate"] is String) {
      modifyDate = json["modifyDate"];
    }
    if (json["creator_id"] is int) {
      creatorId = json["creator_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if (fileId != null) {
      _data["file_id"] = fileId?.toJson();
    }
    _data["note"] = note;
    _data["createDate"] = createDate;
    _data["modifyDate"] = modifyDate;
    _data["creator_id"] = creatorId;
    return _data;
  }

  static List<Note> fromList(List<dynamic> list) {
    var list2 = <Note>[];

    for (dynamic item in list) {
      list2.add(Note.fromJson(item));
    }

    return list2;
  }
}

class FileId {
  int? id;
  int? progress;
  String? progressName;
  String? name;
  String? description;
  List<Images>? images;
  dynamic favorite;
  String? publishedAgo;
  List<Propertys>? propertys;
  Category? category;
  Category? fullCategory;
  City? city;
  bool? status;
  bool? consultantSeen;
  dynamic viewCount;

  FileId(
      {this.id,
      this.progress,
      this.progressName,
      this.name,
      this.description,
      this.images,
      this.favorite,
      this.publishedAgo,
      this.propertys,
      this.category,
      this.city,
      this.status,
      this.consultantSeen,
      this.viewCount});

  FileId.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["progress"] is int) {
      progress = json["progress"];
    }
    if (json["progressName"] is String) {
      progressName = json["progressName"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["images"] is List) {
      images = json["images"] == null ? null : (json["images"] as List).map((e) => Images.fromJson(e)).toList();
    }
    favorite = json["favorite"];
    if (json["publishedAgo"] is String) {
      publishedAgo = json["publishedAgo"];
    }
    if (json["propertys"] is List) {
      propertys = json["propertys"] == null ? null : (json["propertys"] as List).map((e) => Propertys.fromJson(e)).toList();
    }
    if (json["category"] is Map) {
      category = json["category"] == null ? null : Category.fromJson(json["category"]);
    }
    if (json["city"] is Map) {
      city = json["city"] == null ? null : City.fromJson(json["city"]);
    }
    if (json["status"] is bool) {
      status = json["status"];
    }
    if (json["consultantSeen"] is bool) {
      consultantSeen = json["consultantSeen"];
    }
    viewCount = json["viewCount"];

    fullCategory = category;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["progress"] = progress;
    _data["progressName"] = progressName;
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
    if (category != null) {
      _data["category"] = category?.toJson();
    }
    if (city != null) {
      _data["city"] = city?.toJson();
    }
    _data["status"] = status;
    _data["consultantSeen"] = consultantSeen;
    _data["viewCount"] = viewCount;
    return _data;
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
    var list = propertys!.where((element) => meterCondition(element));
    if (list.isNotEmpty) {
      var prop = list.first;

      if (prop.value == null || prop.name == null) return 0;

      return int.parse(prop.value!);
    } else {
      return 0;
    }
  }

  int getFirstPriceInt() {
    var list = propertys!.where((element) => priceCondition(element));
    if (list.isNotEmpty) {
      var prop = list.first;

      if (prop.value == null || prop.name == null) return -1;

      return int.parse(prop.value!);
    } else {
      return -1;
    }
  }

  int getSecondPriceInt() {
    var list = propertys!.where((element) => rentCondition(element));
    if (list.isNotEmpty) {
      var prop = list.first;

      if (prop.value == null || prop.name == null) return -1;

      return int.parse(prop.value!);
    } else {
      return -1;
    }
  }

  String getFirstPrice() {
    var list = propertys!.where((element) => priceCondition(element));

    if (list.isNotEmpty) {
      var prop = list.first;

      if (prop.value == null || prop.name == null) return adaptivePrice(prop.value, name: prop.name);

      return toPrice(prop.value!, prop.name!);
    } else {
      var name = "";
      if (isRent()) name = "ودیعه";
      if (fullCategory?.name?.contains("روزانه") ?? false) name = "اجاره روزانه";
      
      return adaptivePrice("", name: name);
    }
  }

  String getSecondPrice() {
    if (!isRent()) return getPricePerMeter();
    
    var list = propertys!.where((element) => rentCondition(element));

    if (list.isNotEmpty) {
      var prop = list.first;

      if (prop.value == null || prop.name == null) return adaptivePrice(prop.value, name: prop.name);

      return toPrice(prop.value!, prop.name!);
    } else {
      if (fullCategory?.name?.contains("روزانه") ?? false) return "";
      
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
  
  bool fullAdaptive() {
    return (getFirstPriceInt() == -1 && getSecondPriceInt() == -1);
  }

  bool isRent() => fullCategory?.fullCategory?.contains("اجاره") ?? false;

  bool priceCondition(Propertys property) {
    return property.weightList == 5;
  }
  bool rentCondition(Propertys property) {
    return property.weightList == 6;
  }
  bool meterCondition(Propertys property) {
    return property.weightList == 1;
  }
}

class City {
  int? id;
  String? name;
  String? weight;
  String? countFile;

  City({this.id, this.name, this.weight, this.countFile});

  City.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["weight"] is String) {
      weight = json["weight"];
    }
    if (json["countFile"] is String) {
      countFile = json["countFile"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["weight"] = weight;
    _data["countFile"] = countFile;
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
    return fullCategory != null ? fullCategory!.split("-")[0] : null;
  }
}

class Propertys {
  String? name;
  String? value;
  bool? list;
  String? valueItem;
  int? section;
  int? weightList;

  Propertys({this.name, this.value, this.list, this.weightList});

  Propertys.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["value"] is int) {
      value = json["value"].toString();
    }
    if (json["value"] is String) {
      value = json["value"];
    }
    if (json["valueItem"] is String) {
      valueItem = json["valueItem"];
    }
    if (json["valueItem"] is int) {
      valueItem = json["valueItem"].toString();
    }
    if (json["list"] is bool) {
      list = json["list"];
    }
    if (json["section"] is int) {
      section = json["section"];
    }
    if (json["weightList"] is int) {
      weightList = json["weightList"];
    }
    if (weightList == null && json["weightSection"] is int) {
      weightList = json["weightSection"];
    }
    
    if (value == null) value = valueItem;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["value"] = value;
    _data["list"] = list;
    _data["valueItem"] = valueItem;
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

  Images({this.id, this.createDate, this.path, this.status, this.weight, this.name, this.fileId});

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
