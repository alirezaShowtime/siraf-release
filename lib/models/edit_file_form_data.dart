import 'package:siraf3/models/category.dart';
import 'package:siraf3/models/city.dart';
import 'package:latlong2/latlong.dart';
import 'package:siraf3/models/estate.dart';

class EditFileFormData {
  int id;
  Category category;
  City city;
  LatLng location;
  String address;
  String visitPhone;
  String ownerPhone;
  Map<String, String> properties;
  String title;
  String description;
  List<Estate> estates;
  MediaData mediaData;

  EditFileFormData({
    required this.id,
    required this.category,
    required this.city,
    required this.location,
    required this.address,
    required this.visitPhone,
    required this.ownerPhone,
    required this.properties,
    required this.title,
    required this.description,
    required this.estates,
    required this.mediaData,
  });
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
    return deleteImages.isEmpty &&
        deleteVideos.isEmpty &&
        newImages.isEmpty &&
        newVideos.isEmpty &&
        imagesWeight.isEmpty &&
        videosWeight.isEmpty;
  }
}
