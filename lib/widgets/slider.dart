import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Slider {
  ImageProvider<Object> image;
  String? link;
  SliderType type;

  Slider({required this.image, required this.type, this.link,});
}

enum SliderType {
  image, video, virtual_tour,
}
