import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FileImagesScreen extends StatefulWidget {
  var file;
  int? index;

  FileImagesScreen({required this.file, this.index, Key? key}) : super(key: key);

  @override
  State<FileImagesScreen> createState() => _FileImagesScreenState();
}

class _FileImagesScreenState extends State<FileImagesScreen> {
  var imageTitleSetState;

  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();

    currentImageIndex = widget.index ?? 0;
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
              onPageChanged: (i) => imageTitleSetState?.call(() => currentImageIndex = i),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  maxScale: 0.18,
                  minScale: 0.18,
                  imageProvider: NetworkImage(widget.file.media!.image![index].path!),
                  initialScale: PhotoViewComputedScale.covered,
                  heroAttributes: PhotoViewHeroAttributes(tag: widget.file.media!.image![index].id!),
                );
              },
              pageController: PageController(initialPage: widget.index ?? 0),
              itemCount: widget.file.media!.image!.length,
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
                  SizedBox(width: 15),
                  Text(
                    widget.file.name ?? "ناشناس",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
            StatefulBuilder(
              builder: (context, setState) {
                imageTitleSetState = setState;

                String title = widget.file.media?.image?[currentImageIndex].name;

                if (!title.isFill()) return SizedBox();

                return Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: EdgeInsets.only(left: 10, right: 10, top: 100),
                    constraints: BoxConstraints(minWidth: 50),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "IranSansMedium",
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
