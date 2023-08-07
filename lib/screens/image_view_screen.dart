import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:siraf3/widgets/my_back_button.dart';

class ImageViewScreen extends StatefulWidget {
  String? imageUrl;
  File? imageFile;

  ImageViewScreen({this.imageUrl, this.imageFile, Key? key}) : super(key: key);

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
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarDividerColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  minScale: 0.1,
                  maxScale: 0.3,
                  imageProvider: _getProvider(),
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
            Container(
              height: 80,
              color: Colors.black26,
              padding: EdgeInsets.only(top: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyBackButton(color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light, systemNavigationBarIconBrightness: Brightness.light, systemNavigationBarDividerColor: Colors.white),
    );
    super.dispose();
  }

  ImageProvider _getProvider() {
    if (widget.imageFile != null) {
      return FileImage(widget.imageFile!);
    } else {
      return NetworkImage(widget.imageUrl!);
    }
  }
}
