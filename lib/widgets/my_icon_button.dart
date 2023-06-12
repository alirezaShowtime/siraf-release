import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';

class MyIconButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyIconButton();

  Widget? icon;
  IconData? iconData;
  double? size;

  void Function()? onTap;

  MyIconButton({this.iconData, this.icon, this.onTap, this.size = 40});
}

class _MyIconButton extends State<MyIconButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: widget.onTap,
        child: Container(
          height: widget.size,
          width: widget.size,
          alignment: Alignment.center,
          child: widget.icon != null ? widget.icon : icon(widget.iconData!),
        ),
      ),
    );
  }
}
