import 'package:flutter/material.dart';

class IconAsset extends StatefulWidget {
  String icon;
  double? width;
  double? height;
  BoxFit? fit;
  Color? color;
  void Function()? onPressed;

  IconAsset(
      {required this.icon,
      this.width,
      this.height,
      this.fit = BoxFit.fill,
      this.color,
      this.onPressed,
      super.key});

  @override
  State<IconAsset> createState() => _IconAssetState();
}

class _IconAssetState extends State<IconAsset> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onPressed,
      icon: Image(
        image: AssetImage("assets/images/" + widget.icon),
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        color: widget.color,
      ),
    );
  }
}
