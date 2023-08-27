import 'dart:convert';

import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/category.dart';
import 'package:siraf3/models/city.dart';
import 'package:latlong2/latlong.dart';
import 'package:siraf3/models/estate.dart';
import 'package:dio/dio.dart';
import 'dart:io' as io;

class EditFileFormData {
  int id;
  Category category;
  City city;
  LatLng location;
  String address;
  String visitPhone;
  String ownerPhone;
  String visitName;
  String ownerName;
  Map<String, String> properties;
  String title;
  String description;
  String secDescription;
  List<Estate> estates;
  MediaData mediaData;
  bool privateMobile;

  EditFileFormData({
    required this.id,
    required this.category,
    required this.city,
    required this.location,
    required this.address,
    required this.visitPhone,
    required this.ownerPhone,
    required this.visitName,
    required this.ownerName,
    required this.properties,
    required this.title,
    required this.description,
    required this.secDescription,
    required this.estates,
    required this.mediaData,
    this.privateMobile = false,
  });

  Future<FormData> getFormData() async {
    return FormData.fromMap({
      'name': title,
      'long': location.longitude.toString(),
      'lat': location.latitude.toString(),
      'address': address,
      'city_id': city.id!.toString(),
      'category_id': category.id!.toString(),
      'fetcher': jsonEncode(properties),
      'description': description,
      if (visitPhone.isFill()) 'visitPhoneNumber': visitPhone,
      'ownerPhoneNumber': ownerPhone,
      if (visitName.isFill()) 'visitName': visitPhone,
      'ownerName': ownerName,
      if (estates.isNotEmpty) 'estateIds': jsonEncode(estates.map((e) => e.id!).toList()),
        if (privateMobile) 'privateMobile': privateMobile, 
    });
  }
}

class MediaData {
  List<int> deleteImages = [];
  List<int> deleteVideos = [];

  List<Map<String, dynamic>> newImages = [];
  List<Map<String, dynamic>> newVideos = [];

  List<String> imagesWeight = [];
  List<String> videosWeight = [];

  MediaData({
    this.deleteImages = const [],
    this.deleteVideos = const [],
    this.newImages = const [],
    this.newVideos = const [],
    this.imagesWeight = const [],
    this.videosWeight = const [],
  });

  bool isEmpty() {
    return deleteImages.isEmpty && deleteVideos.isEmpty && newImages.isEmpty && newVideos.isEmpty;
    // imagesWeight.isEmpty && // todo remove comment # temporary
    // videosWeight.isEmpty; // todo remove comment # temporary
  }

  Future<FormData> getFormData() async {
    var images = newImages.where((element) => checkImageExtension((element['file'] as io.File).path)).toList();

    var videos = newVideos.where((element) => checkVideoExtension((element['file'] as io.File).path)).toList();

    var formData = FormData.fromMap({
      'labelImages': jsonEncode(images.map((e) => (e['title'] as String?) ?? "").toList()),
      'labelVideos': jsonEncode(videos.map((e) => (e['title'] as String?) ?? "").toList()),
      'weightImages': jsonEncode(imagesWeight),
      'weightVideos': jsonEncode(videosWeight),
      'deleteImages': jsonEncode(deleteImages),
      'deleteVideos': jsonEncode(deleteVideos),
    });

    formData.files.addAll([
      for (Map<String, dynamic> item in images) MapEntry<String, MultipartFile>("images", await MultipartFile.fromFile((item['file'] as io.File).path)),
      for (Map<String, dynamic> item in videos) MapEntry<String, MultipartFile>("videos", await MultipartFile.fromFile((item['file'] as io.File).path)),
    ]);
    return formData;
  }
}
