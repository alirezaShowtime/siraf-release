import 'package:siraf3/models/category.dart';
import 'package:siraf3/models/city.dart';
import 'package:latlong2/latlong.dart';
import 'package:siraf3/models/estate.dart';

class CreateFileFormData {
  Category category;
  City city;
  LatLng location;
  String address;
  Map<String, String> properties;
  List<Map<String, dynamic>> files;
  String title;
  String description;
  List<Estate> estates;

  CreateFileFormData({
    required this.category,
    required this.city,
    required this.location,
    required this.address,
    required this.properties,
    required this.files,
    required this.title,
    required this.description,
    required this.estates,
  });
}
