import 'package:flutter/material.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/widgets/slider.dart' as s;

class File {
  int? id;
  String? name;
  String? description;
  List<Images>? images;
  bool? favorite;
  String? publishedAgo;
  List<Property>? propertys;
  FullCategory? fullCategory;
  City? city;
  String? shareLink;

  File({
    this.id,
    this.name,
    this.description,
    this.images,
    this.favorite,
    this.publishedAgo,
    this.propertys,
    this.fullCategory,
    this.city,
    this.shareLink,
  });

  File.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["images"] is List) {
      images = json["images"] == null ? null : (json["images"] as List).map((e) => Images.fromJson(e)).toList();
    }

    if (json["media"] is Map) {
      Media? media = json["media"] == null ? null : Media.fromJson(json["media"]);
      if (media != null && media.image.isFill()) {
        images = media.image!.map((e) => Images.fromJson(e.toJson())).toList();
      }
    }
    if (json["favorite"] is bool) {
      favorite = json["favorite"];
    }
    if (json["publishedAgo"] is String) {
      publishedAgo = json["publishedAgo"];
    }
    if (json["propertys"] is List) {
      propertys = json["propertys"] == null
          ? null
          : (json["propertys"] as List)
              .map((e) => Property.fromJson(e))
              .where(
                (element) => element.name != null,
              )
              .toList();
    }
    if (json["property"] is List) {
      propertys = json["property"] == null
          ? null
          : (json["property"] as List)
              .map((e) => Property.fromJson(e))
              .where(
                (element) => element.name != null,
              )
              .toList();
    }
    if (json["category"] is Map) {
      fullCategory = json["category"] == null ? null : FullCategory.fromJson(json["category"]);
    }
    if (json["fullCategory"] is Map) {
      fullCategory = json["fullCategory"] == null ? null : FullCategory.fromJson(json["fullCategory"]);
    }
    if (json["city"] is Map) {
      city = json["city"] != null ? City.fromJson(json["city"]) : null;
    }

    if (propertys != null) {
      propertys = propertys!.where((element) => element.weightList != null).toList();
      propertys!.sort((a, b) => a.weightList!.compareTo(b.weightList!));
    }

    if (json["shareLink"] is String) {
      shareLink = json["shareLink"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    if (images != null) {
      _data["images"] = images?.map((e) => e.toJson()).toList();
    }
    _data["favorite"] = favorite;
    _data["publishedAgo"] = publishedAgo;
    if (propertys != null) {
      _data["propertys"] = propertys?.map((e) => e.toJson()).toList();
    }
    if (fullCategory != null) {
      _data["category"] = fullCategory?.toJson();
    }
    _data["city"] = city;
    _data["shareLink"] = shareLink;
    return _data;
  }

  static List<File> fromList(List<dynamic> list) {
    var list2 = <File>[];

    for (dynamic item in list) {
      list2.add(File.fromJson(item));
    }

    return list2;
  }

  String getPricePerMeter() {
    if ((getFirstPriceInt() == -1 || getFirstPriceInt() == 0) || getMeter() == 0) {
      return "";
    }
    var result = getFirstPriceInt() ~/ getMeter();

    if (result == 0) {
      return "";
    }

    var rounded_result = (result / 100000).round() * 100000;

    if (rounded_result != 0) result = rounded_result;

    return "قیمت هر متر " + number_format(result);
  }

  int getPricePerMeterInt() {
    if ((getFirstPriceInt() == -1 || getFirstPriceInt() == 0) || getMeter() == 0) {
      return -1;
    }
    var result = getFirstPriceInt() ~/ getMeter();

    if (result == 0) {
      return -1;
    }

    result = (result / 100000).round() * 100000;

    return result;
  }

  int getMeter() {
    if (propertys!.where((element) => element.weightList == 1).isNotEmpty) {
      var prop = propertys!.firstWhere((element) => element.weightList == 1);

      if (prop.value == null || prop.name == null) return 0;

      return int.parse(prop.value!);
    } else {
      return 0;
    }
  }

  int getFirstPriceInt() {
    if (propertys!.where((element) => element.weightList == 5).isNotEmpty) {
      var prop = propertys!.firstWhere((element) => element.weightList == 5);

      if (prop.value == null || prop.name == null) return -1;

      return int.parse(prop.value!);
    } else {
      return -1;
    }
  }

  int getSecondPriceInt() {
    if (propertys!.where((element) => element.weightList == 6).isNotEmpty) {
      var prop = propertys!.firstWhere((element) => element.weightList == 6);

      if (prop.value == null || prop.name == null) return -1;

      return int.parse(prop.value!);
    } else {
      return -1;
    }
  }

  String getFirstPrice() {
    if (propertys!.where((element) => element.weightList == 5).isNotEmpty) {
      var prop = propertys!.firstWhere((element) => element.weightList == 5);

      if (prop.value == null || prop.name == null) return adaptivePrice(prop.value, name: prop.name);

      return toPrice(prop.value!, prop.name!);
    } else {
      var name = "";
      if (isRent()) name = "ودیعه";
      if (fullCategory?.name?.contains("روزانه") ?? false) name = "اجاره روزانه";
      
      return adaptivePrice("", name: name);
    }
  }

  String getSecondPrice() {
    if (!isRent()) return getPricePerMeter();

    if (propertys!.where((element) => element.weightList == 6).isNotEmpty) {
      var prop = propertys!.firstWhere((element) => element.weightList == 6);

      if (prop.value == null || prop.name == null) return adaptivePrice(prop.value, name: prop.name);

      return toPrice(prop.value!, prop.name!);
    } else {
      if (fullCategory?.name?.contains("روزانه") ?? false) return "";
      
      return adaptivePrice("", name: "اجاره");
    }
  }

  String adaptivePrice(value, {String? name}) {
    if (value.toString() == "0") {
      return "رایگان";
    }
    return (name != null ? "$name " : "") + "توافقی";
  }

  String toPrice(dynamic value, String name) {
    if (value.toString() == "0") {
      return "$name رایگان";
    }

    var v = int.parse(value.toString());

    return "$name ${number_format(v)}";
  }

  Future<List<s.Slider>> getSliders() async {
    var slide_images = images
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

    // var videos = <s.Slider>[];

    // for (Video video in media!.video!) {
    //   final fileName = await VideoThumbnail.thumbnailFile(
    //     video: video.path!,
    //     thumbnailPath: (await getTemporaryDirectory()).path,
    //     imageFormat: ImageFormat.PNG,
    //     quality: 100,
    //   );
    //   videos.add(s.Slider(
    //     image: FileImage(io.File(fileName!)),
    //     type: s.SliderType.video,
    //     link: video.path!,
    //     name: video.name,
    //   ));
    // }

    // var virtualTours = <s.Slider>[];

    // if (media?.virtualTour != null) {
    //   virtualTours.add(s.Slider(
    //     image: AssetImage("assets/images/blue.png"),
    //     type: s.SliderType.virtual_tour,
    //     link: media?.virtualTour,
    //   ));
    // }

    return slide_images; // + videos + virtualTours
  }

  bool fullAdaptive() {
    return (getFirstPriceInt() == -1 && getSecondPriceInt() == -1);
  }

  bool isRent() => fullCategory?.fullCategory?.contains("اجاره") ?? false;
}

class Media {
  List<Video>? video;
  List<Image>? image;
  String? virtualTour;

  Media({this.video, this.image, this.virtualTour});

  Media.fromJson(Map<String, dynamic> json) {
    if (json["Video"] is List) {
      video = json["Video"] == null ? null : (json["Video"] as List).map((e) => Video.fromJson(e)).toList();
    }
    if (json["Image"] is List) {
      image = json["Image"] == null ? null : (json["Image"] as List).map((e) => Image.fromJson(e)).toList();
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
    return fullCategory != null ? fullCategory!.split("-")[0].trim() : null;
  }
}

class Property {
  String? key;
  String? name;
  String? value;
  bool? list;
  int? weightList;

  Property({this.name, this.value, this.list, this.weightList});

  Property.fromJson(Map<String, dynamic> json) {
    if (json["key"] is String) {
      key = json["key"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["value"] is int || json["value"] is String) {
      value = json["value"].toString();
    }
    if (json["list"] is bool) {
      list = json["list"];
    }
    if (json["weightList"] is int) {
      weightList = json["weightList"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["key"] = key;
    _data["name"] = name;
    _data["value"] = value;
    _data["list"] = list;
    _data["weightList"] = weightList;
    return _data;
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

class Images {
  int? id;
  String? createDate;
  String? path;
  bool? status;
  int? weight;
  String? name;
  int? fileId;

  Images({this.id, this.createDate, this.path, this.status, this.weight, this.name, this.fileId});

  Images.fromJson(Map<String, dynamic> json) {
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
