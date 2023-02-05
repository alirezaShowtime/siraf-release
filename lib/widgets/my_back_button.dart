import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';

class MyBackButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyBackButton();

  Color color;

  MyBackButton({this.color = Themes.text});
}

class _MyBackButton extends State<MyBackButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: back(context),
      icon: FaIcon(
        Icons.chevron_left_rounded,
        color: widget.color,
        size: 28,
      ),
    );
  }
}
