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
  Border? border;
  TextDirection? textDirection;
  void Function()? onPressed;

  MyTextIconButton({
    required this.icon,
    this.child,
    this.text,
    this.color,
    this.rippleColor,
    this.onPressed,
    this.textDirection = TextDirection.rtl,
    this.border,
  });
}

class _MyTextIconButton extends State<MyTextIconButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: widget.border,
      ),
      child: MyTextButton(
        onPressed: widget.onPressed,
        rippleColor: widget.rippleColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          textDirection: widget.textDirection,
          children: [
            widget.icon,
            SizedBox(width: 2),
            widget.child ??
                Text(
                  widget.text!,
                  style: TextStyle(
                    color: widget.color ?? widget.rippleColor,
                    fontFamily: "IranSansBold",
                    fontSize: 11,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
