import 'package:siraf3/models/category.dart';
import 'package:siraf3/models/city.dart';
import 'package:latlong2/latlong.dart';
import 'package:siraf3/models/property_insert.dart';

class CreateFileFormData {
  Category category;
  City city;
  LatLng location;
  String address;
  Map<String, String> properties;

  CreateFileFormData({
    required this.category,
    required this.city,
    required this.location,
    required this.address,
    required this.properties,
  });

  
}
