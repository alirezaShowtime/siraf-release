import 'package:flutter/material.dart';
import 'package:siraf3/models/my_file.dart';
import 'package:siraf3/themes.dart';

class MyFileHorizontalItem extends StatefulWidget {
  MyFile file;
  bool isSelectable;
  bool isSelected;
  void Function(bool) onChanged;

  MyFileHorizontalItem({
    required this.file,
    required this.isSelectable,
    required this.isSelected,
    required this.onChanged,
    super.key,
  });

  @override
  State<MyFileHorizontalItem> createState() => _MyFileHorizontalItemState();
}

class _MyFileHorizontalItemState extends State<MyFileHorizontalItem> {
  @override
  Widget build(BuildContext context) {
    double imageSize = (MediaQuery.of(context).size.width - 20) / 3.5;
    if (imageSize > 140) imageSize = 140;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          decoration: BoxDecoration(color: Themes.background2, boxShadow: [
            BoxShadow(
              color: Themes.background,
              blurRadius: 2,
              spreadRadius: 2,
              offset: Offset(0, -3),
            ),
          ]),
          padding: EdgeInsets.all(10),
          // height: imageSize + 20,
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
                    image:
                        AssetImage("assets/images/image_not_avialable_2.png"),
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
                                    color: Themes.text,
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
                                    color: Themes.text,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'IranSans',
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "در انتظار تایید...",
                              style: TextStyle(
                                color: Themes.text,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'IranSans',
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.file.category!
                                  .getMainCategoryName()
                                  .toString() +
                              " | " +
                              widget.file.name!,
                          style: TextStyle(
                            color: Themes.text,
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
                                color: Themes.text,
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
                                    color: Themes.text,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'IranSans',
                                  ),
                                ),
                                Text(
                                  "کد فایل : ${widget.file.id!}",
                                  style: TextStyle(
                                    color: Themes.text,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'IranSans',
                                  ),
                                ),
                                Text(
                                  "بازدید : 497",
                                  style: TextStyle(
                                    color: Themes.text,
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
        ),
        if (widget.isSelectable)
          Positioned(
            left: 15,
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Themes.textGrey.withOpacity(0.2),
                    blurRadius: 2,
                    spreadRadius: 0.2,
                    offset: Offset(0, -1),
                  ),
                  BoxShadow(
                    color: Themes.textGrey.withOpacity(0.2),
                    blurRadius: 2,
                    spreadRadius: 0.2,
                    offset: Offset(-1, 0),
                  ),
                  BoxShadow(
                    color: Themes.textGrey.withOpacity(0.2),
                    blurRadius: 2,
                    spreadRadius: 0.2,
                    offset: Offset(1, 0),
                  ),
                  BoxShadow(
                    color: Themes.textGrey.withOpacity(0.2),
                    blurRadius: 2,
                    spreadRadius: 0.2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Checkbox(
                value: widget.isSelected,
                side: BorderSide(color: Themes.primary, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onChanged: (v) {
                  widget.onChanged(v!);
                },
              ),
            ),
          ),
      ],
    );
  }
}