import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/category.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/estate.dart';
import 'package:dio/dio.dart';
import 'dart:io' as io;

class CreateFileFormData {
  Category category;
  City city;
  LatLng location;
  String address;
  String visitPhone;
  String ownerPhone;
  String visitName;
  String ownerName;
  Map<String, String> properties;
  List<Map<String, dynamic>> files;
  String title;
  String description;
  String? secDescription;
  List<Estate> estates;
  bool privateMobile;

  CreateFileFormData({
    required this.category,
    required this.city,
    required this.location,
    required this.address,
    required this.visitPhone,
    required this.ownerPhone,
    required this.visitName,
    required this.ownerName,
    required this.properties,
    required this.files,
    required this.title,
    required this.description,
    required this.estates,
    this.secDescription,
    this.privateMobile = false,
  });


  Future<FormData> getFormData() async {
    var videos = files.where((element) => checkVideoExtension((element['file'] as io.File).path)).toList();

      var images = files.where((element) => checkImageExtension((element['file'] as io.File).path)).toList();

      var tours = files.where((element) => (element['file'] as io.File).path.endsWith("zip")).toList();
      var tour = tours.isNotEmpty ? tours.first : null;

      var formData = FormData.fromMap({
        'name': title,
        'long': location.longitude.toString(),
        'lat': location.latitude.toString(),
        'address': address,
        'city_id': city.id!.toString(),
        'category_id': category.id!.toString(),
        'fetcher': jsonEncode(properties),
        if (videos.isNotEmpty) 'videosName': jsonEncode(videos.map((e) => (e['title'] as String?) ?? "").toList()),
        if (images.isNotEmpty) 'imagesName': jsonEncode(images.map((e) => (e['title'] as String?) ?? "").toList()),
        'description': description,
        'securityDescription': secDescription,
        if (visitPhone.isFill()) 'visitPhoneNumber': visitPhone,
        'ownerPhoneNumber': ownerPhone,
        'ownerName': ownerName,
        if (visitName.isFill()) 'visitName': visitName,
        if (estates.isNotEmpty) 'estateIds': jsonEncode(estates.map((e) => e.id!).toList()),
        if (privateMobile) 'privateMobile': privateMobile, 
      });

      formData.files.addAll([
        for (Map<String, dynamic> item in images) MapEntry<String, MultipartFile>("images", await MultipartFile.fromFile((item['file'] as io.File).path)),
        for (Map<String, dynamic> item in videos) MapEntry<String, MultipartFile>("videos", await MultipartFile.fromFile((item['file'] as io.File).path)),
        if (tour != null) MapEntry("virtualTour", await MultipartFile.fromFile((tour['file'] as io.File).path)),
      ]);

      return formData;
  }
}
