import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class TextTitle extends StatefulWidget {
  String data;
  Color color;
  String fontFamily;

  TextTitle(
    this.data, {
    this.color = Themes.text,
    this.fontFamily = "IranSansMedium",
    Key? key,
  }) : super(key: key);

  @override
  State<TextTitle> createState() => _TextTitleState();
}

class _TextTitleState extends State<TextTitle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.data,
      style: TextStyle(
        fontFamily: widget.fontFamily,
        fontSize: 15,
      ),
    );
  }
}
