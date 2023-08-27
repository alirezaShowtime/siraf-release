import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/my_back_button.dart';

class ImageViewScreen extends StatefulWidget {
  List<String>? imageUrls;
  List<File>? imageFiles;
  int index;
  String? title;

  ImageViewScreen({
    super.key,
    this.title,
    this.imageUrls,
    this.imageFiles,
    this.index = 1,
  });

  @override
  State<ImageViewScreen> createState() => _ImageViewScreen();
}

class _ImageViewScreen extends State<ImageViewScreen> {
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();

    currentImageIndex = widget.index;
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
              onPageChanged: (i) => currentImageIndex = i,
              builder: (BuildContext context, int i) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: _getProvider(i),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained,
                  initialScale: PhotoViewComputedScale.contained,
                );
              },
              itemCount: widget.imageFiles?.length ?? widget.imageUrls?.length ?? 0,
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
                  SizedBox(width: 10),
                  if (widget.title.isFill()) Flexible(child: AppBarTitle(widget.title!, color: Colors.white, fontSize: 14,)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getProvider(int index) {
    if (widget.imageFiles != null) {
      return FileImage(widget.imageFiles![index]);
    } else {
      return NetworkImage(widget.imageUrls![index]);
    }
  }
}
