import 'package:flutter/material.dart';
import 'package:siraf3/widgets/my_image.dart';

class Avatar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Avatar();

  String? imagePath;
  double size;
  Widget? loadingWidget;
  Widget? errorWidget;
  ImageProvider? image;
  ImageProvider? errorImage;
  ImageProvider? loadingImage;

  Avatar({
    required this.size,
    this.loadingWidget,
    this.imagePath,
    this.image,
    this.errorWidget,
    this.loadingImage,
    this.errorImage,
  });
}

class _Avatar extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.size),
      child: MyImage(
        image: widget.image ?? NetworkImage(widget.imagePath ?? ""),
        height: widget.size,
        width: widget.size,
        borderRadius: BorderRadius.circular(double.infinity),
        fit: BoxFit.cover,
        errorWidget: widget.errorWidget,
        loadingWidget: widget.loadingWidget,
        errorImage: widget.errorImage,
        loadingImage: widget.loadingImage,
      ),
    );
  }
}
