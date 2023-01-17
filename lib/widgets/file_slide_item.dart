import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/auth/login_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/themes2.dart';
import 'package:siraf3/widgets/custom_slider.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:http/http.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CarouselSliderCustom(
                images: widget.file.images
                        ?.map<String>((e) => e.path ?? "")
                        .toList() ??
                    ["no_image_provided"],
                height: 250,
                autoPlay: false,
                indicatorsCenterAlign: true,
                viewportFraction: 1.0,
                itemMargin: EdgeInsets.only(bottom: 15, top: 1),
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
              Positioned(
                bottom: 14,
                left: 0,
                right: 0,
                child: DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashGradient: [Colors.red, Colors.blue],
                  dashRadius: 0.0,
                  dashGapLength: 4.0,
                  dashGapColor: Colors.transparent,
                  dashGapGradient: [Colors.red, Colors.blue],
                  dashGapRadius: 0.0,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashGradient: [Colors.red, Colors.blue],
                  dashRadius: 0.0,
                  dashGapLength: 4.0,
                  dashGapColor: Colors.transparent,
                  dashGapGradient: [Colors.red, Colors.blue],
                  dashGapRadius: 0.0,
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
                      if (await User.hasToken()) {
                        if (await addOrRemoveFavorite()) {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(
                              pop: true,
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      isFavorite
                          ? CupertinoIcons.bookmark_fill
                          : CupertinoIcons.bookmark,
                      color: Themes2.icon,
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
                            color: Themes.text,
                            fontFamily: "IranSans",
                            fontSize: 13,
                          ),
                          maxLines: 2,
                        ),
                        Text(
                          widget.file.publishedAgo! + ' | ' + widget.file.city!,
                          style: TextStyle(
                            color: Themes.textGrey,
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
                    linkUrl: "https://siraf.biz/" + widget.file.id!.toString(),
                    chooserTitle: 'اشتراک گذاری در',
                  );
                },
                icon: Icon(
                  CupertinoIcons.paperplane,
                  color: Themes2.icon,
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
                      .toList()
                      .map<Widget>((e) {
                    return Text(
                      "${e.name} ${e.value}",
                      style: TextStyle(
                        color: Themes.primary,
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
                      color: Themes.primary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'IranSans',
                    ),
                  ),
                  TextSpan(
                      text: showSummary ? ' توضیحات بیشتر' : ' توضیحات کمتر',
                      style: TextStyle(
                        color: Themes.blue,
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
                        }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> addOrRemoveFavorite() async {
    if (isFavorite) {
      return await removeFavorite();
    } else {
      return await addFavorite();
    }
  }

  Future<bool> addFavorite() async {
    showLoadingDialog();

    var result = false;

    try {
      var response = await get(
          getFileUrl(
              'file/addFileFavorite/' + widget.file.id!.toString() + '/'),
          headers: {
            "Authorization": await User.getBearerToken(),
          });

      if (isResponseOk(response)) {
        result = true;
      } else {
        var json = jDecode(response.body);
        notify(json['message'] ??
            "خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
        result = false;
      }
    } on HttpException {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    } catch (e) {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    }

    dissmisLoadingDialog();

    return result;
  }

  Future<bool> removeFavorite() async {
    showLoadingDialog();

    var result = false;

    try {
      var response = await get(
          getFileUrl(
              'file/deleteFileFavorite/' + widget.file.id!.toString() + '/'),
          headers: {
            "Authorization": await User.getBearerToken(),
          });

      if (isResponseOk(response)) {
        result = true;
      } else {
        var json = jDecode(response.body);
        notify(json['message'] ??
            "خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
        result = false;
      }
    } on HttpException {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    } catch (e) {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    }

    dissmisLoadingDialog();

    return result;
  }

  showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        loadingDContext = _;
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    'در حال ارسال درخواست صبور باشید',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Loading(),
              ],
            ),
          ),
        );
      },
    );
  }

  dissmisLoadingDialog() {
    if (loadingDContext != null) {
      Navigator.pop(loadingDContext!);
    }
  }

  BuildContext? loadingDContext;
}
