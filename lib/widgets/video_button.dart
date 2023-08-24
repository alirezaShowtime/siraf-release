import 'package:flutter/material.dart';

class VideoButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayIcon();

  void Function()? onTap;
  IconData icon;
  double size;

  VideoButton({this.onTap, required this.icon, this.size = 40});
}

class _PlayIcon extends State<VideoButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: widget.size,
        width: widget.size,
        padding: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          widget.icon,
          color: Colors.white,
          size: widget.size / 2,
        ),
      ),
    );
  }
}
