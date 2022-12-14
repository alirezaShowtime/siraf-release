import 'package:siraf3/models/city.dart';

class Province {
  int id;
  String name;
  List<City> cities;

  Province({required this.id, required this.name, required this.cities});
}
