import 'package:flutter/material.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/themes.dart';

class TextBigLight extends StatefulWidget {
  String data;
  Color? color;
  String fontFamily;

  TextBigLight(
    this.data, {
    this.color,
    this.fontFamily = "IranSansMedium",
    Key? key,
  }) : super(key: key);

  @override
  State<TextBigLight> createState() => _TextBigLightState();
}

class _TextBigLightState extends State<TextBigLight> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.data,
      style: TextStyle(
        color: widget.color ?? App.theme.canvasColor,
        fontSize: 16,
        fontFamily: widget.fontFamily,
      ),
    );
  }
}
