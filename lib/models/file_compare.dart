
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file.dart';

class FileCompare {
  int? id;
  List<Property>? property;
  int? categoryId;
  File? file;

  FileCompare({this.id, this.property, this.categoryId});

  FileCompare.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["property"] is List) {
      property = json["property"] == null ? null : (json["property"] as List).map((e) => Property.fromJson(e)).toList();
    }
    if(json["category_id"] is int) {
      categoryId = json["category_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if(property != null) {
      _data["property"] = property?.map((e) => e.toJson()).toList();
    }
    _data["category_id"] = categoryId;
    return _data;
  }

  
  static List<FileCompare> fromList(List<dynamic> list) {
    var list2 = <FileCompare>[];

    for (dynamic item in list) {
      list2.add(FileCompare.fromJson(item));
    }

    return list2;
  }

}

class Property {
  String? name;
  String? value;
  int? section;
  int? weightSection;
  String? valueItem;

  Property({this.name, this.value, this.section, this.weightSection});

  Property.fromJson(Map<String, dynamic> json) {
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["value"] is int) {
      value = json["value"].toString();
    }
    if(json["value"] is double) {
      value = json["value"].toString();
    }
    if(json["value"] is String) {
      value = json["value"];
    }
    if (json["valueItem"] is String) {
      valueItem = json["valueItem"];
    }
    if (json["valueItem"] is int) {
      valueItem = json["valueItem"].toString();
    }
    if(json["section"] is int) {
      section = json["section"];
    }
    if(json["weightSection"] is int) {
      weightSection = json["weightSection"];
    }
    
    if (value == null) value = valueItem;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["value"] = value;
    _data["section"] = section;
    _data["weightSection"] = weightSection;
    return _data;
  }

  String getValue() {
    if (value == null) return "-";

    if (isNumeric(value)) {
      return number_format(value);
    }

    return value!;
  }
}