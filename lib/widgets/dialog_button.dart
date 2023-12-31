import 'package:flutter/material.dart';
import 'package:siraf3/main.dart';

class DialogButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DialogButton();

  void Function()? onPressed;
  String labelText;
  Color? color;

  DialogButton({
    required this.labelText,
    this.onPressed,
    this.color,
  });
}

class _DialogButton extends State<DialogButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.color ?? App.theme.primaryColor,
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          constraints: BoxConstraints(
            minWidth: 50,
            minHeight: 55,
          ),
          alignment: Alignment.center,
          child: Text(
            widget.labelText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: "IranSansBold",
            ),
          ),
        ),
      ),
    );
  }
}
