import 'dart:convert';

class Slider {
  String? image;
  String? link;

  Slider({this.image, this.link});

  factory Slider.fromMap(Map<String, dynamic> data) => Slider(
        image: data['image'] as String?,
        link: data['link'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'image': image,
        'link': link,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Slider].
  factory Slider.fromJson(String data) {
    return Slider.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Slider] to a JSON string.
  String toJson() => json.encode(toMap());

  static List<Slider> fromMapList(mapList) {
    List<Slider> list = [];
    for (var map in mapList) {
      list.add(Slider.fromMap(map));
    }
    return list;
  }
}
