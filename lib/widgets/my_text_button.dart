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
  Color? color;
  late Color disableColor;
  Color disableTextColor;
  double? fontSize;
  EdgeInsets? padding;
  bool border;
  late BorderRadius borderRadius;

  Size? minimumSize;
  MaterialTapTargetSize? tapTargetSize;
  bool disable;

  MyTextButton({
    this.text,
    this.onPressed,
    this.rippleColor,
    this.textColor,
    this.color,
    this.child,
    this.padding,
    this.fontSize,
    this.minimumSize,
    this.tapTargetSize,
    this.border = false,
    this.disable = false,
    this.disableTextColor = Colors.grey,
    Color? disableColor,
    BorderRadius? borderRadius,
  }) {
    this.borderRadius = borderRadius ?? BorderRadius.circular(8);

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
        backgroundColor: getColor(),
        foregroundColor: widget.rippleColor ?? Themes.primary,
        tapTargetSize: widget.tapTargetSize,
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius,
        ),
      ),
      child: widget.child ??
          Text(
            widget.text!,
            style: TextStyle(
              fontSize: widget.fontSize ?? 10,
              fontFamily: "IranSansBold",
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
        backgroundColor: getColor(),
        foregroundColor: widget.rippleColor ?? Themes.primary,
        tapTargetSize: widget.tapTargetSize,
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius,
        ),
      ),
      child: widget.child ??
          Text(
            widget.text!,
            style: TextStyle(
              fontSize: widget.fontSize ?? 12,
              fontFamily: "IranSansBold",
              color: widget.disable ? widget.disableTextColor : (widget.textColor ?? widget.rippleColor),
            ),
          ),
    );
  }

  Color? getColor() {
    if (widget.color != null && !widget.disable) return widget.color;

    return widget.disable ? widget.disableColor : null;
  }
}
