import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io' as io;
import 'package:siraf3/widgets/slider.dart' as s;

class FileDetail {
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
  String? city;
  Media? media;
  bool? favorite;

  FileDetail(
      {this.name,
      this.elevator,
      this.countRoom,
      this.meter,
      this.parking,
      this.rent,
      this.prices,
      this.description,
      this.lat,
      this.long,
      this.address,
      this.property,
      this.fullCategory,
      this.publishedAgo,
      this.city,
      this.media,
      this.favorite});

  FileDetail.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["elevator"] is int) {
      elevator = json["elevator"];
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
    if (json["property"] is List) {
      property = json["property"] == null
          ? null
          : (json["property"] as List)
              .map((e) => Property.fromJson(e))
              .toList();
    }
    if (json["fullCategory"] is Map) {
      fullCategory = json["fullCategory"] == null
          ? null
          : FullCategory.fromJson(json["fullCategory"]);
    }
    if (json["publishedAgo"] is String) {
      publishedAgo = json["publishedAgo"];
    }
    if (json["city"] is String) {
      city = json["city"];
    }
    if (json["media"] is Map) {
      media = json["media"] == null ? null : Media.fromJson(json["media"]);
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
    var prices = getPrices();

    return prices.length >= 2;
  }

  Property? getPrice() {
    var prices = getPrices();

    return prices.asMap().containsKey(0) ? prices[0] : null;
  }

  Property? getRent() {
    var prices = getPrices();

    return prices.asMap().containsKey(1) ? prices[1] : null;
  }

  List<Property> getPrices() =>
      property?.where((element) => element.section == 3).toList() ??
      <Property>[];

  List<Property> getMainProperties() {
    var list = property
            ?.where((element) => element.section == 1 && element.value != null)
            .take(6)
            .toList() ??
        [];

    list.sort((a, b) => a.weightSection!.compareTo(b.weightSection!));

    return list;
  }

  List<Property> getOtherProperties() {
    var list = property
            ?.where((element) => element.section == 2 && element.value != null)
            .toList() ??
        [];

    list.sort((a, b) => a.weightSection!.compareTo(b.weightSection!));

    return list;
  }

  Future<List<s.Slider>> getSliders() async {
    var images = media?.image
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

class Media {
  List<Video>? video;
  List<Image>? image;
  String? virtualTour;

  Media({this.video, this.image, this.virtualTour});

  Media.fromJson(Map<String, dynamic> json) {
    if (json["Video"] is List) {
      video = json["Video"] == null
          ? null
          : (json["Video"] as List).map((e) => Video.fromJson(e)).toList();
    }
    if (json["Image"] is List) {
      image = json["Image"] == null
          ? null
          : (json["Image"] as List).map((e) => Image.fromJson(e)).toList();
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
    if (image != null) {
      _data["Image"] = image?.map((e) => e.toJson()).toList();
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

  Image(
      {this.id,
      this.createDate,
      this.path,
      this.status,
      this.weight,
      this.name,
      this.fileId});

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

  Video(
      {this.id,
      this.name,
      this.path,
      this.createData,
      this.status,
      this.weight,
      this.fileId});

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

  FullCategory(
      {this.id,
      this.name,
      this.image,
      this.fullCategory,
      this.isAll,
      this.parentId});

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
  int? value;
  int? section;
  int? weightSection;

  Property({this.name, this.value, this.section, this.weightSection});

  Property.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["value"] is int) {
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
