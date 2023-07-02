import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewScreen extends StatefulWidget {
  String imageUrl;

  ImageViewScreen({required this.imageUrl, Key? key}) : super(key: key);

  @override
  State<ImageViewScreen> createState() => _ImageViewScreen();
}

class _ImageViewScreen extends State<ImageViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            minScale: 0.1,
            imageProvider: NetworkImage(widget.imageUrl),
            initialScale: PhotoViewComputedScale.contained,
          );
        },
        itemCount: 1,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
      ),
    );
  }
}
