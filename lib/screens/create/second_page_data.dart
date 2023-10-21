import 'package:flutter/material.dart';

class SecondPageData {
  String title;
  String ownerPhone;
  String visitPhone;
  String ownerName;
  String visitName;
  late List<Map<String, dynamic>> files;
  late List<Widget> mediaBoxs;

  SecondPageData({
    this.title = "",
    this.ownerPhone = "",
    this.visitPhone = "",
    this.ownerName = "",
    this.visitName = "",
    List<Map<String, dynamic>>? files,
    List<Widget>? mediaBoxs,
  }) {
    this.files = files ?? [];
    this.mediaBoxs = mediaBoxs ?? [];
  }
}
