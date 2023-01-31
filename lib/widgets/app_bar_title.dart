import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class AppBarTitle extends StatefulWidget {
  @override
  State<AppBarTitle> createState() => _AppBarTitle();

  String title;

  AppBarTitle(this.title);
}

class _AppBarTitle extends State<AppBarTitle> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.title, style: TextStyle(fontSize: 15, color: Themes.text));
  }
}
