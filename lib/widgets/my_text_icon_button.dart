import 'package:flutter/material.dart';
import 'package:siraf3/widgets/my_text_button.dart';

class MyTextIconButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyTextIconButton();

  Widget icon;
  Widget? child;
  String? text;
  Color? color;
  Color? rippleColor;
  void Function()? onPressed;

  MyTextIconButton({
    required this.icon,
    this.child,
    this.text,
    this.color,
    this.rippleColor,
    this.onPressed,
  });
}

class _MyTextIconButton extends State<MyTextIconButton> {
  @override
  Widget build(BuildContext context) {
    return MyTextButton(
      onPressed: widget.onPressed,
      rippleColor: widget.rippleColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.icon,
          SizedBox(width: 2),
          widget.child ??
              Text(
                widget.text!,
                style: TextStyle(
                  color: widget.color ?? widget.rippleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
        ],
      ),
    );
  }
}
