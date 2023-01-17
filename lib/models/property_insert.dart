class PropertyInsert {
  int? id;
  String? type;
  List<Items>? items;
  String? name;
  String? value;
  int? insert;
  int? weightInsert;
  bool? require;
  int? categoryId;

  PropertyInsert(
      {this.id,
      this.type,
      this.items,
      this.name,
      this.value,
      this.insert,
      this.weightInsert,
      this.require,
      this.categoryId});

  PropertyInsert.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["type"] is String) {
      type = json["type"];
    }
    if (json["Items"] is List) {
      items = json["Items"] == null
          ? null
          : (json["Items"] as List).map((e) => Items.fromJson(e)).toList();
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["value"] is String) {
      value = json["value"];
    }
    if (json["insert"] is int) {
      insert = json["insert"];
    }
    if (json["weightInsert"] is int) {
      weightInsert = json["weightInsert"];
    }
    if (json["require"] is bool) {
      require = json["require"];
    }
    if (json["category_id"] is int) {
      categoryId = json["category_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["type"] = type;
    if (items != null) {
      _data["Items"] = items?.map((e) => e.toJson()).toList();
    }
    _data["name"] = name;
    _data["value"] = value;
    _data["insert"] = insert;
    _data["weightInsert"] = weightInsert;
    _data["require"] = require;
    _data["category_id"] = categoryId;
    return _data;
  }

  static List<PropertyInsert> fromList(List<dynamic> list) {
    var list2 = <PropertyInsert>[];

    for (dynamic item in list) {
      list2.add(PropertyInsert.fromJson(item));
    }

    return list2;
  }
}

class Items {
  int? id;
  int? value;
  int? weight;
  String? name;
  int? propertyId;

  Items({this.id, this.value, this.weight, this.name, this.propertyId});

  Items.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["value"] is int) {
      value = json["value"];
    }
    if (json["weight"] is int) {
      weight = json["weight"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["property_id"] is int) {
      propertyId = json["property_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["value"] = value;
    _data["weight"] = weight;
    _data["name"] = name;
    _data["property_id"] = propertyId;
    return _data;
  }
}
