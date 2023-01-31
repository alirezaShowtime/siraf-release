import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class User {
  String? token;

  int? id;
  String? name;
  String? username;
  dynamic email;
  String? phone;
  dynamic birthDate;
  String? avatar;
  List<dynamic>? roles;

  User({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.avatar,
    this.birthDate,
    this.token,
  });

  User.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    email = json["email"];
    if (json["phone"] is String) {
      phone = json["phone"];
    }
    birthDate = json["birth_date"];
    if (json["avatar"] is String) {
      avatar = json["avatar"];
    }
    if (json["roles"] is List) {
      roles = json["roles"] ?? [];
    }
    if (json["token"] is String) {
      token = json["token"];
    }
    if (json["username"] is String) {
      token = json["username"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["username"] = username;
    _data["email"] = email;
    _data["phone"] = phone;
    _data["birth_date"] = birthDate;
    _data["avatar"] = avatar;
    if (roles != null) {
      _data["roles"] = roles;
    }
    _data["token"] = token;
    return _data;
  }

  Future<bool> save() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString("user", jsonEncode(toJson()));
  }

  static Future<User> fromLocal() async {
    final pref = await SharedPreferences.getInstance();
    final userJson = pref.getString("user");
    User u;

    if (userJson == null) {
      u = User();
    } else {
      u = User.fromJson(json.decode(userJson));
    }

    return u;
  }

  static Future<void> remove() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove("user");
  }

  int? birthYear() {
    if (birthDate == null) {
      return null;
    }
    return int.parse(birthDate.toString().split("/")[0]);
  }

  int? birthMonth() {
    if (birthDate == null) {
      return null;
    }
    return int.parse(birthDate.toString().split("/")[1]);
  }

  int? birthDay() {
    if (birthDate == null) {
      return null;
    }
    return int.parse(birthDate.toString().split("/")[2]);
  }

  static Future<bool> hasToken() async {
    return ((await User.fromLocal()).token ?? '').trim().isNotEmpty;
  }

  static Future<String> getBearerToken() async {
    return "Bearer " + (await User.fromLocal()).token.toString();
  }
}
