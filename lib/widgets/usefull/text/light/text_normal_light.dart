import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class TextNormalLight extends StatefulWidget {
  String data;
  Color color;
  String fontFamily;

  TextNormalLight(
    this.data, {
    this.color = Themes.textLight,
    this.fontFamily = "IranSansMedium",
    Key? key,
  }) : super(key: key);

  @override
  State<TextNormalLight> createState() => _TextNormalLightState();
}

class _TextNormalLightState extends State<TextNormalLight> {
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
