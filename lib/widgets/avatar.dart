import 'package:flutter/material.dart';

class Avatar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Avatar();

  String? imagePath;
  double size;
  Widget? loadingWidget;
  ImageProvider? image;

  Avatar({
    required this.size,
    this.loadingWidget,
    this.imagePath,
    this.image,
  });
}

class _Avatar extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.size),
      child: Image(
        image: widget.image ?? NetworkImage(widget.imagePath!),
        height: widget.size,
        width: widget.size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progressEvent) {
          if (progressEvent == null) return child;
          return widget.loadingWidget ?? loadingWidget();
        },
      ),
    );
  }

  Widget loadingWidget() {
    return Container(
      height: widget.size,
      width: widget.size,
      color: Colors.grey.shade100,
    );
  }
}
