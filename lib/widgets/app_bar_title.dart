import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class AppBarTitle extends StatefulWidget {
  @override
  State<AppBarTitle> createState() => _AppBarTitle();

  String title;
  double fontSize;

  AppBarTitle(this.title, {this.fontSize = 16});
}

class _AppBarTitle extends State<AppBarTitle> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.title,
        style: TextStyle(fontSize: widget.fontSize, color: Themes.text));
  }
}
