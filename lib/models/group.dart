import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Group {
  int? id;
  String? name;
  dynamic pId;

  Group({this.id, this.name, this.pId});

  Group.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    pId = json["p_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["p_id"] = pId;
    return _data;
  }

  static List<Group> fromList(List<dynamic> list) {
    var list2 = <Group>[];

    for (dynamic item in list) {
      list2.add(Group.fromJson(item));
    }

    return list2;
  }

  static Future<bool> saveList(List<Group> groups, {String? key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(
        key != null ? "{$key}_groups" : "groups", jsonEncode(groups));
  }

  
  static Future<List<Group>> getList({String? key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = jsonDecode(
            prefs.getString(key != null ? "{$key}_groups" : "groups") ?? '[]')
        as List<dynamic>;

    return list.map<Group>((e) => Group.fromJson(e)).toList();
  }
}
