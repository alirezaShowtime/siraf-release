import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';

class MyBackButton extends StatefulWidget {
  Color? color;
  void Function()? onPressed;
  bool? rootNavigator;
  bool shadow;

  MyBackButton({this.color, this.rootNavigator, this.onPressed, this.shadow = false});

  @override
  State<StatefulWidget> createState() => _MyBackButton();
}

class _MyBackButton extends State<MyBackButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onPressed ?? () => back(context, widget.rootNavigator ?? false),
      icon: Icon(
        CupertinoIcons.back,
        color: widget.color ?? App.theme.iconTheme.color,
        shadows: !widget.shadow ? null : [BoxShadow(color: Colors.black87, blurRadius: 3)],
      ),
    );
  }
}
