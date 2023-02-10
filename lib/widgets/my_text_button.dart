import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class MyTextButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyTextButton();

  String? text;
  Widget? child;
  void Function()? onPressed;
  Color? rippleColor;
  Color? textColor;
  EdgeInsets? padding;

  MyTextButton({
    this.text,
    this.onPressed,
    this.rippleColor,
    this.textColor,
    this.child,
    this.padding,
  });
}

class _MyTextButton extends State<MyTextButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      style: TextButton.styleFrom(
        padding: widget.padding,
        foregroundColor: widget.rippleColor ?? Themes.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: widget.child ??
          Text(
            widget.text!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: widget.textColor ?? widget.rippleColor,
            ),
          ),
    );
  }
}
