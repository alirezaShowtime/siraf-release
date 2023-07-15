import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:siraf3/models/file_detail.dart';
import 'package:siraf3/widgets/my_back_button.dart';

class FileImagesScreen extends StatefulWidget {
  FileDetail file;
  int? index;

  FileImagesScreen({required this.file, this.index, Key? key}) : super(key: key);

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
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
                  // maxScale: 4.0,
                  // minScale: 0.5,
                  minScale: 0.1,
                  imageProvider: NetworkImage(widget.file.media!.images![index].path!),
                  initialScale: PhotoViewComputedScale.contained,
                  heroAttributes: PhotoViewHeroAttributes(tag: widget.file.media!.images![index].id!),
                );
              },
              pageController: PageController(initialPage: widget.index ?? 0),
              itemCount: widget.file.media!.images!.length,
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
                  SizedBox(width: 10,),
                  Text(
                    widget.file.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
