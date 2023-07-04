import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/custom_slider.dart';
import 'package:siraf3/widgets/slider.dart' as s;
import 'package:siraf3/bookmark.dart';

class FileSlideItem extends StatefulWidget {
  File file;

  FileSlideItem({required this.file, super.key});

  @override
  State<FileSlideItem> createState() => _FileSlideItemState();
}

class _FileSlideItemState extends State<FileSlideItem> {
  late String description = "";

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

    bookmark =
        Bookmark(id: widget.file.id!, isFavorite: isFavorite, context: context);

    bookmark.favoriteStream.stream.listen((bool data) {
      setState(() {
        isFavorite = data;
      });
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
                    image: DecorationImage(
                        image: AssetImage(IMAGE_NOT_AVAILABLE),
                        alignment: Alignment.center),
                  ),
                ),
              if (widget.file.images != null && widget.file.images!.isNotEmpty)
                CarouselSliderCustom(
                  sliders: widget.file.images!
                      .map<s.Slider>(
                        (e) => s.Slider(
                          image: NetworkImage(e.path ?? ""),
                          type: s.SliderType.image,
                          link: e.path ?? "",
                        ),
                      )
                      .toList(),
                  height: 250,
                  autoPlay: false,
                  indicatorsCenterAlign: true,
                  viewportFraction: 1.0,
                  itemMargin: EdgeInsets.only(bottom: 15),
                  indicatorPosition:
                      EdgeInsets.only(left: 0, right: 0, bottom: 0),
                  itemBorderRadius: BorderRadius.zero,
                  imageFit: BoxFit.cover,
                  indicatorSelectedColor: Themes.blue,
                  indicatorColor: Colors.grey,
                ),
              if (widget.file.getFirstPrice().isNotEmpty ||
                  widget.file.getSecondPrice().isNotEmpty)
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
                        if (widget.file.getFirstPrice().isNotEmpty)
                          Text(
                            widget.file.getFirstPrice(),
                            style: TextStyle(
                              color: Themes.textLight,
                              fontFamily: "IranSans",
                              fontSize: 14,
                            ),
                          ),
                        if (widget.file.getFirstPrice().isEmpty &&
                            widget.file.getSecondPrice().isNotEmpty)
                          SizedBox(
                            height: 5,
                          ),
                        if (widget.file.getSecondPrice().isNotEmpty)
                          Text(
                            widget.file.getSecondPrice(),
                            style: TextStyle(
                              color: Themes.textLight,
                              fontFamily: "IranSans",
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              if (widget.file.getFirstPrice().isEmpty &&
                  widget.file.getSecondPrice().isEmpty)
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
                            color: Themes.textLight,
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
          SizedBox(
            height: 4,
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      doWithLogin(context, () async {
                        bookmark.addOrRemoveFavorite();
                      });
                    },
                    icon: Icon(
                      isFavorite
                          ? CupertinoIcons.bookmark_fill
                          : CupertinoIcons.bookmark,
                      color: App.theme.iconTheme.color,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (widget.file.fullCategory != null
                                  ? widget.file.fullCategory!
                                          .getMainCategoryName()
                                          .toString()
                                          .trim() +
                                      " | "
                                  : "") +
                              widget.file.name!.trim(),
                          style: TextStyle(
                            color: App.theme.textTheme.bodyLarge?.color,
                            fontFamily: "IranSans",
                            fontSize: 13,
                          ),
                          maxLines: 2,
                        ),
                        Text(
                          widget.file.publishedAgo! +
                              ' | ' +
                              (widget.file.city?.name ?? ""),
                          style: TextStyle(
                            color: App.theme.tooltipTheme.textStyle?.color,
                            fontFamily: "IranSans",
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              IconButton(
                onPressed: () async {
                  await FlutterShare.share(
                    title: 'اشتراک گذاری فایل',
                    text: widget.file.name ?? '',
                    linkUrl: FILE_URL + widget.file.id!.toString(),
                    chooserTitle: 'اشتراک گذاری در',
                  );
                },
                icon: Image(
                  image: AssetImage("assets/images/ic_share.png"),
                  width: 16,
                  height: 16,
                  color: App.theme.iconTheme.color,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: widget.file.propertys
                      ?.where((element) =>
                          element.weightList == 1 ||
                          element.weightList == 2 ||
                          element.weightList == 3 ||
                          element.weightList == 4)
                      .take(4)
                      .toList()
                      .map<Widget>((e) {
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
                          print("tappped");
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
