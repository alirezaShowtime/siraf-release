import 'package:siraf3/models/consultant_info.dart';

class EstateProfile {
  int? id;
  int? countConstruction;
  int? countRent;
  int? countOnSale;
  int? status;
  String? guildCode;
  String? name;
  String? bio;
  String? logoFile;
  String? shareLink;
  String? address;
  String? video;
  List<Images> images = [];
  double? rate;
  String? description;
  List<Comment>? comments;
  List<Consultants>? consultants;

  String? phoneNumber;
  String? telephoneNumber;
  String? statusString;
  double? lat;
  double? long;
  String? managerName;

  EstateProfile.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["phoneNumber"] is String) {
      phoneNumber = json["phoneNumber"];
    }
    if (json["telephoneNumber"] is String) {
      telephoneNumber = json["telephoneNumber"];
    }
    if (json["statusString"] is String) {
      statusString = json["statusString"];
    }
    if (json["lat"] is String) {
      lat = double.parse(json["lat"]);
    }
    if (json["long"] is String) {
      long = double.parse(json["long"]);
    }
    if (json["countConstruction"] is int) {
      countConstruction = json["countConstruction"];
    }
    if (json["managerName"] is String) {
      managerName = json["managerName"];
    }
    if (json["countRent"] is int) {
      countRent = json["countRent"];
    }
    if (json["countOnSale"] is int) {
      countOnSale = json["countOnSale"];
    }
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["guildCode"] is String) {
      guildCode = json["guildCode"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["bio"] is String) {
      bio = json["bio"];
    }
    if (json["logoFile"] is String) {
      logoFile = json["logoFile"];
    }
    if (json["address"] is String) {
      address = json["address"];
    }
    if (json["video"] is String) {
      video = json["video"];
    }
    if (json["shareLink"] is String) {
      shareLink = json["shareLink"];
    }
    if (json["images"] is List) {
      images = json['images'] == null ? [] : Images.fromList(json["images"]);
    }
    if (json["rate"] is double) {
      rate = json["rate"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["comment"] is List) {
      comments = json["comment"] == null ? null : (json["comment"] as List).map((e) => Comment.fromJson(e)).toList();
    }
    if (json["consultants"] is List) {
      consultants = json["consultants"] == null ? null : (json["consultants"] as List).map((e) => Consultants.fromJson(e)).toList();
    }
  }
}

class Consultants {
  int? id;
  String? name;
  String? phone;
  String? avatar;
  double? rate;

  Consultants({this.id, this.name, this.phone, this.avatar, this.rate});

  Consultants.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["phone"] is String) {
      phone = json["phone"];
    }
    if (json["avatar"] is String) {
      avatar = json["avatar"];
    }
    if (json["rate"] is double) {
      rate = json["rate"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["phone"] = phone;
    _data["avatar"] = avatar;
    _data["rate"] = rate;
    return _data;
  }
}

class Image {
  String? path;

  Image(this.path);

  Image.fromJson(Map<String, dynamic> json) {
    if (json["path"] is String) {
      path = json["path"];
    }
  }
}

class Images {
  int? id;
  String? image;

  Images({this.id, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["image"] is String) {
      image = json["image"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["image"] = image;
    return _data;
  }

  static List<Images> fromList(List<dynamic> list) {
    var list2 = <Images>[];

    for (dynamic item in list) {
      list2.add(Images.fromJson(item));
    }

    return list2;
  }
}
