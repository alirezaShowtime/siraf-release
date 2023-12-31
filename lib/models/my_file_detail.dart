import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/estate.dart';
import 'package:siraf3/widgets/slider.dart' as s;
import 'package:siraf3/models/file_detail.dart' as fd;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io' as io;

class MyFileDetail {
  int? id;
  String? name;
  String? description;
  String? progressString;
  String? address;
  int? progress;
  String? ownerPhoneNumber;
  String? visitPhoneNumber;
  String? ownerName;
  String? visitName;
  String? secDescription;
  String? rejectionDesc;
  Media? media;
  String? publishedAgo;
  String? createDateTimeAgo;
  List<Propertys>? propertys;
  String? lat;
  int? viewCount;
  String? long;
  String? fullCategory;
  String? city;
  Category? category;
  CityFull? cityFull;
  List<Estate>? estates;
  String? comment;
  int? expireDay;

  MyFileDetail({
    this.id,
    this.name,
    this.description,
    this.progressString,
    this.progress,
    this.ownerPhoneNumber,
    this.visitPhoneNumber,
    this.media,
    this.publishedAgo,
    this.createDateTimeAgo,
    this.propertys,
    this.lat,
    this.address,
    this.long,
    this.fullCategory,
    this.city,
    this.estates,
    this.viewCount,
    this.comment,
  });

  MyFileDetail.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["comment"] is String) {
      rejectionDesc = json["comment"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["progressString"] is String) {
      progressString = json["progressString"];
    }
    if (json["progress"] is int) {
      progress = json["progress"];
    }
    if (json["viewCount"] is int) {
      viewCount = json["viewCount"];
    }
    if (json["ownerPhoneNumber"] is String) {
      ownerPhoneNumber = json["ownerPhoneNumber"];
    }
    if (json["visitPhoneNumber"] is String) {
      visitPhoneNumber = json["visitPhoneNumber"];
    }
    if (json["ownerName"] is String) {
      ownerName = json["ownerName"];
    }
    if (json["visitName"] is String) {
      visitName = json["visitName"];
    }
    if (json["securityDescription"] is String) {
      secDescription = json["securityDescription"];
    }
    if (json["media"] is Map) {
      media = json["media"] == null ? null : Media.fromJson(json["media"]);
    }
    if (json["publishedAgo"] is String) {
      publishedAgo = json["publishedAgo"];
    }
    if (json["createDateTimeAgo"] is String) {
      createDateTimeAgo = json["createDateTimeAgo"];
    }
    if (json["propertys"] is List) {
      propertys = json["propertys"] == null
          ? null
          : (json["propertys"] as List)
              .map((e) => Propertys.fromJson(e))
              .toList();
    }
    if (json["lat"] is String) {
      lat = json["lat"];
    }
    if (json["long"] is String) {
      long = json["long"];
    }
    if (json["fullCategory"] is String) {
      fullCategory = json["fullCategory"];
    }
    if (json["city"] is String) {
      city = json["city"];
    }
    if (json["address"] is String) {
      address = json["address"];
    }
    if (json["category"] is Map) {
      category =
          json["category"] == null ? null : Category.fromJson(json["category"]);
    }
    if (json["cityFull"] is Map) {
      cityFull =
          json["cityFull"] == null ? null : CityFull.fromJson(json["cityFull"]);
    }
    if (json['estates'] is List) {
      estates =
          json['esates'] == null ? null : Estate.fromList(json['estates']);
    }
    if (json["comment"] is String) {
      comment = json["comment"];
    }
    if (json["expireDay"] is int) {
      expireDay = json["expireDay"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    _data["progressString"] = progressString;
    _data["progress"] = progress;
    _data["ownerPhoneNumber"] = ownerPhoneNumber;
    _data["visitPhoneNumber"] = visitPhoneNumber;
    _data["ownerName"] = ownerName;
    _data["visitName"] = visitName;
    _data["securityDescription"] = secDescription;
    if (media != null) {
      _data["media"] = media?.toJson();
    }
    _data["publishedAgo"] = publishedAgo;
    _data["createDateTimeAgo"] = createDateTimeAgo;
    if (propertys != null) {
      _data["propertys"] = propertys?.map((e) => e.toJson()).toList();
    }
    _data["lat"] = lat;
    _data["long"] = long;
    _data["fullCategory"] = fullCategory;
    if (category != null) {
      _data["category"] = category?.toJson();
    }
    _data["city"] = city;
    _data["comment"] = comment;
    if (cityFull != null) {
      _data["cityFull"] = cityFull?.toJson();
    }
    return _data;
  }

  List<Propertys> getMainProperties() {
    var list = propertys
            ?.where((element) => element.section == 1 && element.value != null)
            .take(6)
            .toList() ??
        [];

    list.sort((a, b) => a.weightSection!.compareTo(b.weightSection!));

    return list;
  }

  List<Propertys> getOtherProperties() {
    var list = propertys
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
                id: e.id,
              ),
            )
            .toList() ??
        [];

    var videos = <s.Slider>[];

    for (fd.Video video in media!.video!) {
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
        id: video.id,
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

  bool isRental() {
    return category?.fullCategory.toString().contains("اجاره") ?? false;
  }

  Propertys? getPrice() {
    var prices = getPrices();

    return prices.asMap().containsKey(0) ? prices[0] : null;
  }

  Propertys? getRent() {
    var prices = getPrices();

    return prices.asMap().containsKey(1) ? prices[1] : null;
  }

  List<Propertys> getPrices() =>
      propertys?.where((element) => element.section == 3).toList() ??
      <Propertys>[];

  String getPricePerMater() {
    var mater =
        (propertys?.where((element) => element.name.toString().contains('متر')).length ??
                    0) >
                0
            ? (propertys
                    ?.firstWhere((element) => element.name.toString().contains('متر'))
                    .value ??
                -1)
            : -2;

    if (mater == -2) return "توافقی";

    if (getPrice()?.value == null) {
      return "توافقی";
    }

    if (getPrice()?.value == "0") {
      return "رایگان";
    }

    if (mater == -1 || mater == null) {
      return "متراژ نامشخص";
    }
    
    var result = int.parse(getPrice()!.value!) ~/ int.parse(mater.toString());

    if (result == 0) {
      return "نامشخص";
    }

    var rounded_result = (result / 100000).round() * 100000;

    if (rounded_result != 0) result = rounded_result;

    return number_format(result);
  }
  
  String toPrice(dynamic value) {
    if (value.toString() == "0") {
      return "رایگان";
    }

    var v = int.parse(value.toString());

    return number_format(v);
  }
  
  String getPriceStr() {
    return getPrice()?.value != null ? toPrice(getPrice()!.value) : "توافقی";
  }

  String getRentStr() {
    return getRent()?.value != null ? rentText(getRent()?.value) : "توافقی";
  }

  bool isExpired() => expireDay != null && expireDay! <= 3;
  
  String rentText(String? value) {
    if (value == "0") return "رایگان";
    
    return number_format(value);
  }
}

class Propertys {
  int? id;
  String? key;
  String? name;
  String? value;  
  String? valueItem;
  int? section;
  int? weightSection;

  Propertys(
      {this.id,
      this.key,
      this.name,
      this.value,
      this.section,
      this.weightSection});

  Propertys.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["value"] is int) {
      value = json["value"].toString();
    }
    if (json["value"] is String) {
      value = json["value"];
    }
    if (json["valueItem"] is String) {
      valueItem = json["valueItem"];
    }
    if (json["valueItem"] is int) {
      valueItem = json["valueItem"].toString();
    }
    if (json["key"] is String) {
      key = json["key"];
    }
    if (json["section"] is int) {
      section = json["section"];
    }
    if (json["weightSection"] is int) {
      weightSection = json["weightSection"];
    }

    if (value == null) value = valueItem;

    print("$name : $value");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["value"] = value;
    _data["valueItem"] = valueItem;
    _data["section"] = section;
    _data["weightSection"] = weightSection;
    return _data;
  }
}

class Media {
  List<fd.Video>? video;
  List<fd.Image>? image;
  String? virtualTour;

  Media({this.video, this.image, this.virtualTour});

  Media.fromJson(Map<String, dynamic> json) {
    if (json["Video"] is List) {
      video = json["Video"] == null
          ? null
          : (json["Video"] as List).map((e) => fd.Video.fromJson(e)).toList();
    }
    if (json["Image"] is List) {
      image = json["Image"] == null
          ? null
          : (json["Image"] as List).map((e) => fd.Image.fromJson(e)).toList();

      if (image != null) {
        image!.sort((a, b) => (a.weight ?? 0).compareTo(b.weight ?? 0));
      }
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
  
  bool isFill() {
    return image.isFill() || video.isFill() || virtualTour != null;
  }
}

class CityFull {
  int? id;
  int? countFile;
  String? name;
  int? weight;
  int? parentId;

  CityFull({this.id, this.countFile, this.name, this.weight, this.parentId});

  CityFull.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["countFile"] is int) {
      countFile = json["countFile"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["weight"] is int) {
      weight = json["weight"];
    }
    if (json["parent_id"] is int) {
      parentId = json["parent_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["countFile"] = countFile;
    _data["name"] = name;
    _data["weight"] = weight;
    _data["parent_id"] = parentId;
    return _data;
  }
}

class Category {
  int? id;
  String? name;
  dynamic image;
  String? fullCategory;
  bool? isAll;
  int? parentId;

  Category(
      {this.id,
      this.name,
      this.image,
      this.fullCategory,
      this.isAll,
      this.parentId});

  Category.fromJson(Map<String, dynamic> json) {
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
