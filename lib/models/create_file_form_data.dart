import 'package:siraf3/models/category.dart';
import 'package:siraf3/models/city.dart';
import 'package:latlong2/latlong.dart';
import 'package:siraf3/models/estate.dart';

class CreateFileFormData {
  Category category;
  City city;
  LatLng location;
  String address;
  String visitPhone;
  String ownerPhone;
  Map<String, String> properties;
  List<Map<String, dynamic>> files;
  String title;
  String description;
  String? secDescription;
  List<Estate> estates;

  CreateFileFormData({
    required this.category,
    required this.city,
    required this.location,
    required this.address,
    required this.visitPhone,
    required this.ownerPhone,
    required this.properties,
    required this.files,
    required this.title,
    required this.description,
    required this.estates,
    this.secDescription,
  });
}
