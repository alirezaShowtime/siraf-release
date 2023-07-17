import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class City {
  int? id;
  String? name;
  int? weight;
  int? countFile;
  int? parentId;
  String? lat;
  String? long;

  City({this.id, this.name, this.weight, this.countFile, this.parentId, this.lat, this.long});

  City.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["weight"] is int) {
      weight = json["weight"];
    }
    if (json["countFile"] is int) {
      countFile = json["countFile"];
    }
    if (json["parent_id"] is int) {
      parentId = json["parent_id"];
    }
    if (json["lat"] is String) {
      lat = json["lat"];
    }
    if (json["long"] is String) {
      long = json["long"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["weight"] = weight;
    _data["countFile"] = countFile;
    _data["parent_id"] = parentId;
    _data["lat"] = lat;
    _data["long"] = long;
    return _data;
  }

  static List<City> fromList(List<dynamic> list) {
    var list2 = <City>[];

    for (dynamic item in list) {
      list2.add(City.fromJson(item));
    }

    return list2;
  }

  static Future<bool> saveList(List<City> cities, {String? key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(
        key != null ? "{$key}_cities" : "cities", jsonEncode(cities));
  }

  static Future<List<City>> getList({String? key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = jsonDecode(
            prefs.getString(key != null ? "{$key}_cities" : "cities") ?? '[]')
        as List<dynamic>;

    return list.map<City>((e) => City.fromJson(e)).toList();
  }
}
