import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../themes.dart';

class BlockBtn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BlockBtn();

  String text;
  Function() onTap;
  EdgeInsets? padding;
  double height;
  Color color;
  double radius;
  bool isLoading;
  bool disable;
  double? textSize;

  BlockBtn({
    required this.text,
    required this.onTap,
    this.padding,
    this.height = 60,
    this.color = Themes.blue,
    this.radius = 15,
    this.isLoading = false,
    this.disable = false,
    this.textSize,
  });
}

class _BlockBtn extends State<BlockBtn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(10),
      child: MaterialButton(
        disabledElevation: 0,
        disabledTextColor: widget.disable ? Colors.grey : null,
        disabledColor: _disabledColor(),
        minWidth: double.infinity,
        onPressed: widget.isLoading ? null : widget.onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.radius)),
        height: widget.height,
        color: widget.color,
        textColor: Colors.white,
        elevation: 0,
        child: widget.isLoading ? _loading() : _text(),
      ),
    );
  }

  Widget _loading() {
    return SizedBox(
      width: 20,
      height: 20,
      child: SpinKitRing(color: Colors.white, size: 20, lineWidth: 3),
    );
  }

  Widget _text() {
    return Text(
      widget.text,
      style: TextStyle(
        fontSize: widget.textSize ?? 15,
        color: Colors.white,
        fontFamily: "IranSansBold",
      ),
    );
  }

  Color? _disabledColor() {
    if (widget.disable) {
      return Colors.grey.shade100;
    }

    if (widget.isLoading) {
      return widget.color;
    }
    return null;
  }
}
