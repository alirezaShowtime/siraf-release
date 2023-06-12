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
  late Color disableColor;
  Color disableTextColor;
  double? fontSize;
  EdgeInsets? padding;
  bool border;

  Size? minimumSize;
  MaterialTapTargetSize? tapTargetSize;
  bool disable;

  MyTextButton({
    this.text,
    this.onPressed,
    this.rippleColor,
    this.textColor,
    this.child,
    this.padding,
    this.fontSize,
    this.minimumSize,
    this.tapTargetSize,
    this.border = false,
    this.disable = false,
    this.disableTextColor = Colors.grey,
    Color? disableColor,
  }) {
    if (disableColor == null) {
      this.disableColor = Colors.grey.shade100;
    }
  }
}

class _MyTextButton extends State<MyTextButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.border) return _outlineBorder();

    return TextButton(
      onPressed: widget.disable ? null : widget.onPressed,
      style: TextButton.styleFrom(
        padding: widget.padding,
        minimumSize: widget.minimumSize,
        backgroundColor: widget.disable ? widget.disableColor : null,
        foregroundColor: widget.rippleColor ?? Themes.primary,
        tapTargetSize: widget.tapTargetSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: widget.child ??
          Text(
            widget.text!,
            style: TextStyle(
              fontSize: widget.fontSize ?? 12,
              fontWeight: FontWeight.bold,
              color: widget.disable ? widget.disableTextColor : (widget.textColor ?? widget.rippleColor),
            ),
          ),
    );
  }

  Widget _outlineBorder() {
    return OutlinedButton(
      onPressed: widget.disable ? null : widget.onPressed,
      style: TextButton.styleFrom(
        padding: widget.padding,
        minimumSize: widget.minimumSize,
        backgroundColor: widget.disable ? widget.disableColor : null,
        foregroundColor: widget.rippleColor ?? Themes.primary,
        tapTargetSize: widget.tapTargetSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: widget.child ??
          Text(
            widget.text!,
            style: TextStyle(
              fontSize: widget.fontSize ?? 12,
              fontWeight: FontWeight.bold,
              color: widget.disable ? widget.disableTextColor : (widget.textColor ?? widget.rippleColor),
            ),
          ),
    );
  }
}
