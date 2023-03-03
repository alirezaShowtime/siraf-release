import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/usefull/text/text_big.dart';

class ButtonPrimary extends StatefulWidget {
  void Function()? onPressed;
  String text;
  double height;
  double width;
  bool fullWidth;
  double elevation;
  BorderRadius? borderRadius;
  Color color;

  ButtonPrimary({
    required this.text,
    this.height = 50,
    this.width = 0,
    this.fullWidth = false,
    this.elevation = 0,
    this.onPressed = null,
    this.borderRadius,
    this.color = Themes.primary,
    Key? key,
  }) : super(key: key);

  @override
  State<ButtonPrimary> createState() => _ButtonPrimaryState();
}

class _ButtonPrimaryState extends State<ButtonPrimary> {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: widget.onPressed,
      child: TextBig(widget.text, color: Themes.textLight),
      shape: RoundedRectangleBorder(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
      ),
      elevation: widget.elevation,
      constraints: BoxConstraints(
        minHeight: widget.height,
        minWidth: widget.fullWidth ? double.infinity : widget.width,
      ),
      fillColor: widget.color,
    );
  }
}
