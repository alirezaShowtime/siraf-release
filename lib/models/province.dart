import 'package:siraf3/models/city.dart';

class Province {
  int id;
  String name;
  int? weight;
  int? countFile;
  dynamic parentId;
  List<City> cities;

  Province(
      {required this.id,
      required this.name,
      required this.weight,
      required this.countFile,
      required this.parentId,
      required this.cities});
}
