import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';

class MyIconButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyIconButton();

  Widget? icon;
  IconData? iconData;
  double? size;
  bool disable;
  Color? iconColor;

  GestureTapCallback? onTap;

  MyIconButton({this.iconData, this.icon, this.onTap, this.size = 40, this.disable = false, this.iconColor});
}

class _MyIconButton extends State<MyIconButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: !widget.disable ? widget.onTap : null,
        child: Container(
          height: widget.size,
          width: widget.size,
          alignment: Alignment.center,
          child: widget.icon != null ? widget.icon : icon(widget.iconData!, color: widget.disable ? Colors.grey.shade400 : widget.iconColor),
        ),
      ),
    );
  }
}
