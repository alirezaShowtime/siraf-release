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
  String? address;
  String? video;
  List<Image>? images;
  double? rate;
  String? description;
  List<Comment>? comment;
  List<Consultants>? consultants;

  EstateProfile({this.id, this.countConstruction, this.countRent, this.countOnSale, this.status, this.guildCode, this.name, this.bio, this.logoFile, this.address, this.video, this.images, this.rate, this.description, this.comment, this.consultants});

  EstateProfile.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["countConstruction"] is int) {
      countConstruction = json["countConstruction"];
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
    if (json["images"] is String) {
      images = json["images"];
    }
    if (json["rate"] is double) {
      rate = json["rate"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["comment"] is List) {
      comment = json["comment"] == null ? null : (json["comment"] as List).map((e) => Comment.fromJson(e)).toList();
    }
    if (json["consultants"] is List) {
      consultants = json["consultants"] == null ? null : (json["consultants"] as List).map((e) => Consultants.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["countConstruction"] = countConstruction;
    _data["countRent"] = countRent;
    _data["countOnSale"] = countOnSale;
    _data["status"] = status;
    _data["guildCode"] = guildCode;
    _data["name"] = name;
    _data["bio"] = bio;
    _data["logoFile"] = logoFile;
    _data["address"] = address;
    _data["video"] = video;
    _data["images"] = images;
    _data["rate"] = rate;
    _data["description"] = description;
    if (comment != null) {
      _data["comment"] = comment?.map((e) => e.toJson()).toList();
    }
    if (consultants != null) {
      _data["consultants"] = consultants?.map((e) => e.toJson()).toList();
    }
    return _data;
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

  fromJson(Map<String, dynamic> json) {
    if (json["path"] is String) {
      path = json["path"];
    }
  }
}
