import 'package:flutter/material.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/my_file.dart';
import 'package:siraf3/themes.dart';

class MyFileHorizontalItem extends StatefulWidget {
  MyFile file;
  bool isSelected;

  MyFileHorizontalItem({
    super.key,
    required this.file,
    required this.isSelected,
  });

  @override
  State<MyFileHorizontalItem> createState() => _MyFileHorizontalItemState();
}

class _MyFileHorizontalItemState extends State<MyFileHorizontalItem> {
  Map<int, String> progress_fa = {
    1: "در انتظار پذیرش",
    2: "رد شده",
    3: "رد شده",
    4: "تایید شده",
    5: "در انتظار پذیرش",
    6: "پذیرش نشده",
    7: "پذیرش شده",
  };

  Map<int, Color> progress_color = {
    1: Themes.textGrey,
    2: Colors.red,
    3: Colors.red,
    4: Colors.green,
    5: App.isDark ? Themes.textLight : Themes.text,
    6: Colors.yellow,
    7: Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    double imageSize = (MediaQuery.of(context).size.width - 20) / 3.5;
    if (imageSize > 140) imageSize = 140;
    return Container(
      decoration:
          BoxDecoration(color: App.theme.dialogBackgroundColor, boxShadow: [
        BoxShadow(
          color: App.theme.backgroundColor,
          blurRadius: 1,
          spreadRadius: 1,
          offset: Offset(0, -1),
        ),
      ]),
      foregroundDecoration: BoxDecoration(
        color: widget.isSelected
            ? Themes.blue.withOpacity(0.2)
            : Colors.transparent,
      ),
      padding: EdgeInsets.all(10),
      constraints: BoxConstraints(maxHeight: 160),
      width: double.infinity,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: NetworkImage(widget.file.images?.first.path ?? ""),
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image(
                image: AssetImage(IMAGE_NOT_AVAILABLE),
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.file.getFirstPrice(),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IranSans',
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              widget.file.getSecondPrice(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'IranSans',
                              ),
                            ),
                          ],
                        ),
                        Text(
                          progress_fa[widget.file.progress] ?? "نامشخص",
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'IranSansMedium',
                            color: progress_color[widget.file.progress],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.file.category!.getMainCategoryName().toString() +
                          " | " +
                          widget.file.name!,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'IranSans',
                      ),
                      maxLines: 2,
                    ),
                    Column(
                      children: [
                        Text(
                          '',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'IranSans',
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.file.publishedAgo ?? "",
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'IranSans',
                              ),
                            ),
                            Text(
                              "کد فایل : ${widget.file.id!}",
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'IranSans',
                              ),
                            ),
                            Text(
                              "بازدید : ${widget.file.viewCount}",
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'IranSans',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
