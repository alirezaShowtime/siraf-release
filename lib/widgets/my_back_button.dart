import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';

class MyBackButton extends StatefulWidget {
  Color? color;
  void Function()? onPressed;

  MyBackButton({this.color, this.onPressed});

  @override
  State<StatefulWidget> createState() => _MyBackButton();
}

class _MyBackButton extends State<MyBackButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onPressed ?? () => back(context),
      icon: Icon(
        CupertinoIcons.back,
        color: widget.color,
      ),
    );
  }
}
