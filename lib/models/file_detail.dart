import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/widgets/slider.dart' as s;
import 'package:video_thumbnail/video_thumbnail.dart';

class FileDetail {
  int? id;
  String? name;
  int? elevator;
  int? countRoom;
  int? meter;
  int? parking;
  int? rent;
  int? prices;
  String? description;
  String? lat;
  String? long;
  String? address;
  List<Property>? property;
  FullCategory? fullCategory;
  String? publishedAgo;
  City? city;
  Media? media;
  bool? favorite;
  Image? firstImage;

  FileDetail.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["elevator"] is int) {
      elevator = json["elevator"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["countRoom"] is int) {
      countRoom = json["countRoom"];
    }
    if (json["meter"] is int) {
      meter = json["meter"];
    }
    if (json["parking"] is int) {
      parking = json["parking"];
    }
    rent = json["rent"];
    if (json["prices"] is int) {
      prices = json["prices"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["lat"] is String) {
      lat = json["lat"];
    }
    if (json["long"] is String) {
      long = json["long"];
    }
    if (json["address"] is String) {
      address = json["address"];
    }
    if (json["propertys"] is List) {
      property = json["propertys"] == null ? null : (json["propertys"] as List).map((e) => Property.fromJson(e)).toList();
    }
    if (json["category"] is Map) {
      fullCategory = json["category"] == null ? null : FullCategory.fromJson(json["category"]);
    }
    if (json["publishedAgo"] is String) {
      publishedAgo = json["publishedAgo"];
    }
    if (json["cityFull"] is Map) {
      city = json["cityFull"] == null ? null : City.fromJson(json["cityFull"]);
    }
    if (json["media"] is Map) {
      media = json["media"] == null ? null : Media.fromJson(json["media"]);

      if (media != null && media!.images.isFill()) {
        firstImage = media!.images!.first;
      }
    }
    if (json["favorite"] is bool) {
      favorite = json["favorite"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["elevator"] = elevator;
    _data["countRoom"] = countRoom;
    _data["meter"] = meter;
    _data["parking"] = parking;
    _data["rent"] = rent;
    _data["prices"] = prices;
    _data["description"] = description;
    _data["lat"] = lat;
    _data["long"] = long;
    _data["address"] = address;
    if (property != null) {
      _data["property"] = property?.map((e) => e.toJson()).toList();
    }
    if (fullCategory != null) {
      _data["fullCategory"] = fullCategory?.toJson();
    }
    _data["publishedAgo"] = publishedAgo;
    _data["city"] = city;
    if (media != null) {
      _data["media"] = media?.toJson();
    }
    _data["favorite"] = favorite;
    return _data;
  }

  bool isRental() {
    return fullCategory?.getMainCategoryName().toString().contains("اجاره") ?? false;

    var prices = getPrices();

    return prices.length >= 2;
  }

  Property? getPrice() {
    var prices = getPrices();

    return prices.asMap().containsKey(0) ? prices[0] : null;
  }

  String getPriceStr() {
    return getPrice()?.value != null ? number_format(int.parse(getPrice()!.value!)) : "توافقی";
  }

  String getPricePerMeter() {
    if (getFirstPriceInt() == 0 || getMeter() == 0) {
      return "توافقی";
    }
    var result = getFirstPriceInt() ~/ getMeter();

    if (result == 0) {
      return "توافقی";
    }

    var rounded_result = (result / 100000).round() * 100000;

    if (rounded_result != 0) result = rounded_result;

    return number_format(result);
  }

  int getMeter() {
    if (property!.where((element) => element.key == "meter").isNotEmpty) {
      var prop = property!.firstWhere((element) => element.key == "meter");

      if (prop.value == null || prop.name == null) return 0;

      return int.parse(prop.value!);
    } else {
      return 0;
    }
  }

  int getFirstPriceInt() {
    if (getPrices().isNotEmpty) {
      var prop = getPrices().first;

      if (prop.value == null || prop.name == null) return 0;

      return int.parse(prop.value!);
    } else {
      return 0;
    }
  }

  Property? getVadie() {
    if (property!.where((element) => element.key == "prices").isNotEmpty) {
      return property!.firstWhere((element) => element.key == "prices");
    }

    return null;
  }

  String getVadieStr() {
    return getVadie()?.value != null ? number_format(int.parse(getVadie()!.value!)) : "توافقی";
  }

  Property? getRent() {
    if (property!.where((element) => element.key == "rent").isNotEmpty) {
      return property!.firstWhere((element) => element.key == "rent");
    }

    return null;
  }

  String getRentStr() {
    return getRent()?.value != null ? number_format(int.parse(getRent()!.value!)) : "توافقی";
  }

  List<Property> getPrices() => property?.where((element) => element.section == 3).toList() ?? <Property>[];

  List<Property> getMainProperties() {
    var list = property?.where((element) => element.section == 1 && element.value != null).take(6).toList() ?? [];

    list.sort((a, b) => a.weightSection!.compareTo(b.weightSection!));

    return list;
  }

  List<Property> getOtherProperties() {
    var list = property?.where((element) => element.section == 2 && element.value != null).toList() ?? [];

    list.sort((a, b) => a.weightSection!.compareTo(b.weightSection!));

    return list;
  }

  Future<List<s.Slider>> getSliders() async {
    var images = media?.images
            ?.map<s.Slider>(
              (e) => s.Slider(
                image: NetworkImage(e.path ?? ""),
                link: e.path ?? "",
                type: s.SliderType.image,
                name: e.name,
              ),
            )
            .toList() ??
        [];

    var videos = <s.Slider>[];

    for (Video video in media!.video!) {
      final fileName = await VideoThumbnail.thumbnailFile(
        video: video.path!,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        quality: 100,
      );
      videos.add(s.Slider(
        image: FileImage(io.File(fileName!)),
        type: s.SliderType.video,
        link: video.path!,
        name: video.name,
      ));
    }

    var virtualTours = <s.Slider>[];

    if (media?.virtualTour != null) {
      virtualTours.add(s.Slider(
        image: AssetImage("assets/images/blue.png"),
        type: s.SliderType.virtual_tour,
        link: media?.virtualTour,
      ));
    }

    return images + videos + virtualTours;
  }
}

class City {
  int? id;
  String? name;
  String? weight;
  String? countFile;

  City({this.id, this.name, this.weight, this.countFile});

  City.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["weight"] is String) {
      weight = json["weight"];
    }
    if (json["countFile"] is String) {
      countFile = json["countFile"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["weight"] = weight;
    _data["countFile"] = countFile;
    return _data;
  }
}

class Media {
  List<Video>? video;
  List<Image>? images;
  String? virtualTour;

  Media({this.video, this.images, this.virtualTour});

  Media.fromJson(Map<String, dynamic> json) {
    if (json["Video"] is List) {
      video = json["Video"] == null ? null : (json["Video"] as List).map((e) => Video.fromJson(e)).toList();
    }
    if (json["Image"] is List) {
      images = json["Image"] == null ? null : (json["Image"] as List).map((e) => Image.fromJson(e)).toList();
    }
    if (json["virtualTour"] is String) {
      virtualTour = json["virtualTour"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (video != null) {
      _data["Video"] = video?.map((e) => e.toJson()).toList();
    }
    if (images != null) {
      _data["Image"] = images?.map((e) => e.toJson()).toList();
    }
    _data["virtualTour"] = virtualTour;
    return _data;
  }
}

class Image {
  int? id;
  String? createDate;
  String? path;
  bool? status;
  int? weight;
  String? name;
  int? fileId;

  Image({this.id, this.createDate, this.path, this.status, this.weight, this.name, this.fileId});

  Image.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if (json["path"] is String) {
      path = json["path"];
    }
    if (json["status"] is bool) {
      status = json["status"];
    }
    if (json["weight"] is int) {
      weight = json["weight"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["file_id"] is int) {
      fileId = json["file_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["createDate"] = createDate;
    _data["path"] = path;
    _data["status"] = status;
    _data["weight"] = weight;
    _data["name"] = name;
    _data["file_id"] = fileId;
    return _data;
  }
}

class Video {
  int? id;
  String? name;
  String? path;
  String? createData;
  bool? status;
  int? weight;
  int? fileId;

  Video({this.id, this.name, this.path, this.createData, this.status, this.weight, this.fileId});

  Video.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["path"] is String) {
      path = json["path"];
    }
    if (json["createData"] is String) {
      createData = json["createData"];
    }
    if (json["status"] is bool) {
      status = json["status"];
    }
    if (json["weight"] is int) {
      weight = json["weight"];
    }
    if (json["file_id"] is int) {
      fileId = json["file_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["path"] = path;
    _data["createData"] = createData;
    _data["status"] = status;
    _data["weight"] = weight;
    _data["file_id"] = fileId;
    return _data;
  }
}

class FullCategory {
  int? id;
  String? name;
  dynamic image;
  String? fullCategory;
  bool? isAll;
  int? parentId;

  FullCategory({this.id, this.name, this.image, this.fullCategory, this.isAll, this.parentId});

  FullCategory.fromJson(Map<String, dynamic> json) {
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

class Property {
  String? name;
  String? key;
  String? value;
  int? section;
  int? weightSection;

  Property({this.name, this.value, this.key, this.section, this.weightSection});

  Property.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["key"] is String) {
      key = json["key"];
    }
    if (json["value"] is int) {
      value = json["value"].toString();
    }
    if (json["value"] is String) {
      value = json["value"];
    }
    if (json["section"] is int) {
      section = json["section"];
    }
    if (json["weightSection"] is int) {
      weightSection = json["weightSection"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["value"] = value;
    _data["section"] = section;
    _data["weightSection"] = weightSection;
    return _data;
  }
}
