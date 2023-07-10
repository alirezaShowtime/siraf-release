import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyButton();

  bool disable;
  void Function()? onPressed;

  MyButton({
    this.disable = false,
    this.onPressed,
  });
}

class _MyButton extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      enableFeedback: !widget.disable,
      onPressed: widget.onPressed,
    );
  }
}
