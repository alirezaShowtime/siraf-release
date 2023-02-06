import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class MyTextButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyTextButton();

  String text;
  void Function()? onPressed;
  Color? rippleColor;
  Color? textColor;

  MyTextButton({
    required this.text,
    this.onPressed,
    this.rippleColor,
    this.textColor,
  });
}

class _MyTextButton extends State<MyTextButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      style: TextButton.styleFrom(
        foregroundColor: widget.rippleColor ?? Themes.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: widget.textColor ?? widget.rippleColor,
        ),
      ),
    );
  }
}
