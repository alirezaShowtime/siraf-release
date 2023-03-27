import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/file_detail.dart';
import 'package:siraf3/themes.dart';

class FileImagesScreen extends StatefulWidget {
  FileDetail file;
  int? index;

  FileImagesScreen({required this.file, this.index, Key? key})
      : super(key: key);

  @override
  State<FileImagesScreen> createState() => _FileImagesScreenState();
}

class _FileImagesScreenState extends State<FileImagesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.file.name ?? '',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            maxScale: 4.0,
            minScale: 0.5,
            imageProvider: NetworkImage(widget.file.media!.image![index].path!),
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(
                tag: widget.file.media!.image![index].id!),
          );
        },
        pageController: PageController(initialPage: widget.index ?? 0),
        itemCount: widget.file.media!.image!.length,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
      ),
    );
  }
}
