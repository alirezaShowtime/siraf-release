import 'package:flutter/cupertino.dart';

class Slider {
  ImageProvider<Object> image;
  String? link;
  SliderType type;
  String? name;
  int? id;

  Slider({
    required this.image,
    required this.type,
    this.name,
    this.link,
    this.id,
  });
}

enum SliderType {
  image,
  video,
  virtual_tour,
}
