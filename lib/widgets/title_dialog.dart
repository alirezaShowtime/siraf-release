import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class TitleDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TitleDialog();

  String title;

  TitleDialog({required this.title});
}

class _TitleDialog extends State<TitleDialog> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title,
      style: TextStyle(
        color: Themes.text,
        fontFamily: "IranSansBold",
        fontSize: 15,
      ),
    );
  }
}
