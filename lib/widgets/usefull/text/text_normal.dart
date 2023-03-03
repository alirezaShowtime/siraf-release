import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class TextNormal extends StatefulWidget {
  String data;
  Color color;
  String fontFamily;

  TextNormal(
    this.data, {
    this.color = Themes.text,
    this.fontFamily = "IranSansMedium",
    Key? key,
  }) : super(key: key);

  @override
  State<TextNormal> createState() => _TextNormalState();
}

class _TextNormalState extends State<TextNormal> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.data,
      style: TextStyle(
        color: widget.color,
        fontSize: 14,
        fontFamily: widget.fontFamily,
      ),
    );
  }
}
