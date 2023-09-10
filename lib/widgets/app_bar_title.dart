import 'package:flutter/material.dart';
import 'package:siraf3/main.dart';

class AppBarTitle extends StatefulWidget {
  @override
  State<AppBarTitle> createState() => _AppBarTitle();

  String title;
  double fontSize;
  Color? color;

  AppBarTitle(this.title, {this.fontSize = 16, this.color});
}

class _AppBarTitle extends State<AppBarTitle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title,
      style: TextStyle(
        fontSize: widget.fontSize,
        color: widget.color ?? App.theme.textTheme.bodyLarge?.color,
        fontFamily: "IranSansBold",
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
