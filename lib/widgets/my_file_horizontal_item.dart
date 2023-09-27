import 'package:flutter/material.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/dark_themes.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/my_file.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_image.dart';

class MyFileHorizontalItem extends StatefulWidget {
  MyFile file;
  bool isSelected;

  MyFileHorizontalItem({required this.file, this.isSelected = false, super.key});

  @override
  State<MyFileHorizontalItem> createState() => _MyFileHorizontalItemState();
}

class _MyFileHorizontalItemState extends State<MyFileHorizontalItem> {
  Map<int, String> progress_fa = {
    1: "در انتظار تایید",
    2: "رد شده",
    3: "رد شده",
    4: "تایید شده",
    5: "در انتظار پذیرش",
    6: "پذیرش نشده",
    7: "پذیرش شده",
  };

  Map<int, Color> progress_color = {
    1: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
    2: Colors.red,
    3: Colors.red,
    4: Colors.green,
    5: App.isDark ? App.theme.canvasColor : App.theme.textTheme.bodyLarge?.color ?? Themes.text,
    6: Colors.yellow,
    7: Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: App.theme.dialogBackgroundColor,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            spreadRadius: -1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        color: widget.isSelected ? Themes.blue.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(13),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyImage(
                borderRadius: BorderRadius.circular(10),
                image: NetworkImage(widget.file.images?.first.path ?? ""),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                loadingWidget: loadingImage(),
                errorWidget: loadingImage(),
              ),
              SizedBox(width: 10),
              SizedBox(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 210,
                            child: Text(
                              widget.file.name!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: App.theme.textTheme.bodyLarge?.color,
                                fontSize: 14,
                                fontFamily: 'IranSansBold',
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.file.category?.getMainCategoryName() ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: App.theme.textTheme.bodyLarge?.color,
                                  fontSize: 11,
                                  fontFamily: 'IranSansMedium',
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                (widget.file.publishedAgo ?? "") + ' | ' + (widget.file.city ?? ""),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'IranSans',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.file.getFirstPrice(),
                              style: TextStyle(
                                color: App.theme.textTheme.bodyLarge?.color,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IranSans',
                              ),
                            ),
                            SizedBox(height: 3),
                            if (widget.file.getSecondPrice().isFill())
                              Text(
                                widget.file.getSecondPrice(),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 10.5,
                                  fontFamily: 'IranSansMedium',
                                ),
                              ),
                          ],
                        ),
                        Text(
                          progress_fa[widget.file.progress] ?? "نامشخص",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: progress_color[widget.file.progress],
                            fontSize: 11,
                            fontFamily: 'IranSansMedium',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.file.publishedAgo ?? "",
                          style: TextStyle(
                            color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'IranSans',
                          ),
                        ),
                        Text(
                          "کد فایل : ${widget.file.id}",
                          style: TextStyle(
                            color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'IranSans',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.file.isExpired())
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                "فایل در حال انقضا است جهت تمدید روی فایل کلیک کنید",
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: "IranSansBold",
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget loadingImage() {
    return Container(
      width: 100,
      height: 100,
      color: App.isDark ? DarkThemes.background : Colors.grey.shade100,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/siraf_logo.png",
            color: App.isDark ? DarkThemes.iconGrey : Colors.grey.shade300,
            scale: 8.5,
          ),
          SizedBox(height: 4),
          Image.asset(
            "assets/images/siraf_logo_text.png",
            color: App.isDark ? DarkThemes.iconGrey : Colors.grey.shade300,
            scale: 7,
          ),
        ],
      ),
    );
  }
}
