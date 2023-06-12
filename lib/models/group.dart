import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class GroupModel {
  int? id;
  String? name;
  dynamic pId;

  GroupModel({this.id, this.name, this.pId});

  GroupModel.fromJson(Map<String, dynamic> json) {
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

  static List<GroupModel> fromList(List<dynamic> list) {
    var list2 = <GroupModel>[];

    for (dynamic item in list) {
      list2.add(GroupModel.fromJson(item));
    }

    return list2;
  }

  static Future<bool> saveList(List<GroupModel> groups, {String? key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key != null ? "{$key}_groups" : "groups", jsonEncode(groups));
  }

  static Future<List<GroupModel>> getList({String? key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = jsonDecode(prefs.getString(key != null ? "{$key}_groups" : "groups") ?? '[]') as List<dynamic>;

    return list.map<GroupModel>((e) => GroupModel.fromJson(e)).toList();
  }
}
