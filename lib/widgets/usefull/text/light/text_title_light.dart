import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/main.dart';

class TextTitleLight extends StatefulWidget {
  String data;
  Color? color;
  String fontFamily;

  TextTitleLight(
    this.data, {
    this.color,
    this.fontFamily = "IranSansMedium",
    Key? key,
  }) : super(key: key);

  @override
  State<TextTitleLight> createState() => _TextTitleLightState();
}

class _TextTitleLightState extends State<TextTitleLight> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.data,
      style: TextStyle(
        color: widget.color ?? App.theme.canvasColor,
        fontFamily: widget.fontFamily,
        fontSize: 15,
      ),
    );
  }
}
