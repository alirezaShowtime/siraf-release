import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class User {
  String? id;
  String? fullName;
  dynamic phone;
  String? phoneNumber;
  String? profileSource;
  String? bio;
  int? gender;
  dynamic birthDate;
  String? token;
  int? type;
  bool? hasProfile;

  User({
    this.id,
    this.fullName,
    this.phone,
    this.phoneNumber,
    this.profileSource,
    this.bio,
    this.gender,
    this.birthDate,
    this.token,
    this.type,
    this.hasProfile,
  });

  factory User.fromMap(Map<String, dynamic> data) => User(
        id: data['id'] as String?,
        fullName: data['fullName'] as String?,
        phone: data['phone'] as dynamic,
        phoneNumber: data['phoneNumber'] as String?,
        profileSource: data['profileSource'] as String?,
        bio: data['bio'] as String?,
        gender: data['gender'] as int?,
        birthDate: data['birthDate'] as dynamic,
        token: data['token'] as String?,
        type: data['type'] as int?,
        hasProfile: data['hasProfile'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'fullName': fullName,
        'phone': phone,
        'phoneNumber': phoneNumber,
        'profileSource': profileSource,
        'bio': bio,
        'gender': gender,
        'birthDate': birthDate,
        'token': token,
        'type': type,
        'hasProfile': hasProfile,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());

  Future<bool> save() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString("user", toJson());
  }

  static Future<User> fromLocal() async {
    final pref = await SharedPreferences.getInstance();
    final userJson = pref.getString("user");
    User u;

    if (userJson == null) {
      u = User();
    } else {
      u = User.fromMap(json.decode(userJson) as Map<String, dynamic>);
    }

    u.token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjczODU1MzA4LCJpYXQiOjE2NzM2ODI1MDgsImp0aSI6IjJhNGQyNGNlMGVkNjRiM2Y5MDE0Y2I1OTNlZjZhZTRlIiwidXNlcl9pZCI6MTB9.AnhHpzAF20VQGYmTjbYp1rq4ATur-brmm-SmNA2EvhE";


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

  bool isConsultant() {
    return type == 100; // type 100 is consultant
  }

  static Future<String> getBearerToken() async {
    return "Bearer " + (await User.fromLocal()).token.toString();
  }
}
