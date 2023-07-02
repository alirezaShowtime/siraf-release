import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/estate.dart';

class Request {
  int? id;
  String? createDate;
  String? statusString;
  CategoryId? categoryId;
  int? cityId;
  City? city;
  int? minPrice;
  int? maxPrice;
  String? title;
  int? maxMeter;
  int? minMeter;
  int? status;
  String? description;
  String? commentOperator;
  bool? isDelete;
  int? userId;
  String? customerNumber;
  List<Estate>? estates;

  Request({
    this.id,
    this.createDate,
    this.statusString,
    this.categoryId,
    this.cityId,
    this.minPrice,
    this.maxPrice,
    this.title,
    this.maxMeter,
    this.minMeter,
    this.status,
    this.description,
    this.commentOperator,
    this.isDelete,
    this.userId,
    this.customerNumber,
    this.estates,
  });

  static List<Request> fromList(List<dynamic> list) {
    var list2 = <Request>[];

    for (dynamic item in list) {
      list2.add(Request.fromJson(item));
    }

    return list2;
  }

  Request.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if (json["statusString"] is String) {
      statusString = json["statusString"];
    }
    if (json["category_id"] is Map) {
      categoryId = json["category_id"] == null
          ? null
          : CategoryId.fromJson(json["category_id"]);
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
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["commentOperator"] is String) {
      commentOperator = json["commentOperator"];
    }
    if (json["isDelete"] is bool) {
      isDelete = json["isDelete"];
    }
    if (json["user_id"] is int) {
      userId = json["user_id"];
    }
    if (json["customerNumber"] is String) {
      customerNumber = json["customerNumber"];
    }
    if (json["city"] is Map) {
      city = json["city"] == null ? null : City.fromJson(json["city"]);
    }
    if (json['estates'] is List) {
      estates = Estate.fromList(json['estates']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["createDate"] = createDate;
    _data["statusString"] = statusString;
    if (categoryId != null) {
      _data["category_id"] = categoryId?.toJson();
    }
    _data["city_id"] = cityId;
    _data["minPrice"] = minPrice;
    _data["maxPrice"] = maxPrice;
    _data["title"] = title;
    _data["maxMeter"] = maxMeter;
    _data["minMeter"] = minMeter;
    _data["status"] = status;
    _data["description"] = description;
    _data["commentOperator"] = commentOperator;
    _data["isDelete"] = isDelete;
    _data["user_id"] = userId;
    _data["customerNumber"] = customerNumber;
    _data['city'] = city?.toJson();
    _data['estates'] = estates?.map((e) => e.toJson()).toList();
    return _data;
  }
}

class CategoryId {
  int? id;
  String? name;
  dynamic image;
  String? fullCategory;
  bool? isAll;
  int? parentId;

  CategoryId(
      {this.id,
      this.name,
      this.image,
      this.fullCategory,
      this.isAll,
      this.parentId});

  CategoryId.fromJson(Map<String, dynamic> json) {
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
