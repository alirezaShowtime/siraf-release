import 'package:flutter/material.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/themes.dart';

class TextBig extends StatefulWidget {
  String data;
  Color? color;
  String fontFamily;

  TextBig(
    this.data, {
    this.color,
    this.fontFamily = "IranSansMedium",
    Key? key,
  }) : super(key: key);

  @override
  State<TextBig> createState() => _TextBigState();
}

class _TextBigState extends State<TextBig> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.data,
      style: TextStyle(
        color: widget.color ?? App.theme.textTheme.bodyLarge?.color,
        fontSize: 16,
        fontFamily: widget.fontFamily,
      ),
    );
  }
}
