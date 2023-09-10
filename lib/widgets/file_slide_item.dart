import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:siraf3/bookmark.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/custom_slider.dart';
import 'package:siraf3/widgets/slider.dart' as s;

import 'my_icon_button.dart';

class FileSlideItem extends StatefulWidget {
  File file;

  FileSlideItem({required this.file, super.key});

  @override
  State<FileSlideItem> createState() => _FileSlideItemState();
}

class _FileSlideItemState extends State<FileSlideItem> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late String description = "";

  List<s.Slider> sliders = [];

  late String summary = "";

  bool showSummary = true;

  bool isFavorite = false;

  late Bookmark bookmark;

  @override
  void initState() {
    super.initState();

    setState(() {
      isFavorite = widget.file.favorite ?? false;

      description = widget.file.description ?? "";
      summary = widget.file.description ?? "";

      if (summary.length > 128 && summary.substring(0, 128).contains("\n")) {
        summary = summary.substring(0, summary.indexOf("\n")) + "...";
      } else if (summary.length > 128) {
        summary = summary.substring(0, 128) + "...";
      }
    });

    bookmark = Bookmark(id: widget.file.id!, isFavorite: isFavorite, context: context);

    bookmark.favoriteStream.stream.listen((bool data) {
      setState(() {
        isFavorite = data;
      });
    });

    setSliders();
  }
  
  void setSliders() async {
    var data = await widget.file.getSliders();
    setState(() {
      sliders = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              if (widget.file.images == null || widget.file.images!.isEmpty)
                Container(
                  padding: EdgeInsets.only(bottom: 15),
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(IMAGE_NOT_AVAILABLE), alignment: Alignment.center),
                  ),
                ),
              if (widget.file.images != null && widget.file.images!.isNotEmpty)
                CarouselSliderCustom(
                  sliders: sliders,
                  height: 250,
                  autoPlay: false,
                  indicatorsCenterAlign: true,
                  viewportFraction: 1.0,
                  itemMargin: EdgeInsets.only(bottom: 15),
                  indicatorMargin: EdgeInsets.only(bottom: 15),
                  float: true,
                  itemBorderRadius: BorderRadius.zero,
                  imageFit: BoxFit.cover,
                  indicatorSelectedColor: Themes.blue,
                  indicatorColor: Colors.grey,
                  onImageTap: (slide) {
                    push(
                      context,
                      FileScreen(id: widget.file.id!),
                    );
                  },
                ),
              if (widget.file.getFirstPrice().isNotEmpty || widget.file.getSecondPrice().isNotEmpty)
                Positioned(
                  bottom: 22.5,
                  right: 7.5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: (App.isDark ? Color.fromARGB(255, 202, 202, 202) : Color(0xff6c6c6c)).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.file.getFirstPrice().isNotEmpty)
                          Text(
                            widget.file.getFirstPrice(),
                            style: TextStyle(
                              color: App.theme.canvasColor,
                              fontFamily: "IranSans",
                              fontSize: 14,
                            ),
                          ),
                        if (widget.file.getFirstPrice().isEmpty && widget.file.getSecondPrice().isNotEmpty)
                          SizedBox(
                            height: 5,
                          ),
                        if (widget.file.getSecondPrice().isNotEmpty)
                          Text(
                            widget.file.getSecondPrice(),
                            style: TextStyle(
                              color: App.theme.canvasColor,
                              fontFamily: "IranSans",
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              if (widget.file.getFirstPrice().isEmpty && widget.file.getSecondPrice().isEmpty)
                Positioned(
                  bottom: 22.5,
                  right: 7.5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff6c6c6c).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "توافقی",
                          style: TextStyle(
                            color: App.theme.canvasColor,
                            fontFamily: "IranSans",
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (widget.file.fullCategory != null ? widget.file.fullCategory!.getMainCategoryName().toString().trim() + " | " : "") + widget.file.name!.trim(),
                          style: TextStyle(
                            color: App.theme.textTheme.bodyLarge?.color,
                            fontFamily: "IranSansMedium",
                            fontSize: 14,
                          ),
                          maxLines: 2,
                        ),
                        Text(
                          widget.file.publishedAgo! + ' | ' + (widget.file.city?.name ?? ""),
                          style: TextStyle(
                            color: App.theme.tooltipTheme.textStyle?.color,
                            fontFamily: "IranSansMedium",
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              MyIconButton(
                onTap: () async {
                  await FlutterShare.share(
                    title: 'اشتراک گذاری فایل',
                    text: widget.file.name ?? '',
                    linkUrl: widget.file.shareLink,
                    chooserTitle: 'اشتراک گذاری در',
                  );
                },
                icon: icon(
                  Icons.share_rounded,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  widget.file.propertys?.where((element) => element.weightList == 1 || element.weightList == 2 || element.weightList == 3 || element.weightList == 4).take(4).toList().map<Widget>((e) {
                        return Text(
                          "${e.name} ${nonIfZero(e.value)}",
                          style: TextStyle(
                            color: App.theme.textTheme.bodyLarge?.color,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'IranSans',
                          ),
                        );
                      }).toList() ??
                      [],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: showSummary ? summary : description,
                    style: TextStyle(
                      color: App.theme.textTheme.bodyLarge?.color,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'IranSans',
                    ),
                  ),
                  if (description.length > summary.length)
                    TextSpan(
                      text: showSummary ? ' توضیحات بیشتر' : ' توضیحات کمتر',
                      style: TextStyle(
                        color: App.theme.primaryColor,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'IranSans',
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            showSummary = !showSummary;
                          });
                        },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
