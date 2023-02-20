import 'package:flutter/material.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/themes.dart';

class FileHorizontalItem extends StatefulWidget {
  File file;

  FileHorizontalItem({required this.file, super.key});

  @override
  State<FileHorizontalItem> createState() => _FileHorizontalItemState();
}

class _FileHorizontalItemState extends State<FileHorizontalItem> {
  @override
  Widget build(BuildContext context) {
    double imageSize = (MediaQuery.of(context).size.width - 20) / 3.5;
    if (imageSize > 140) imageSize = 140;
    return Container(
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
                image: AssetImage("assets/images/image_not_avialable_2.png"),
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
                                fontSize: 14,
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
                          widget.file.publishedAgo! + ' | ' + widget.file.city!,
                          style: TextStyle(
                            color: Themes.text,
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'IranSans',
                          ),
                        ),
                      ],
                    ),
                    Text(
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
                          children: widget.file.propertys
                                  ?.where((element) =>
                                      element.weightList == 1 ||
                                      element.weightList == 2 ||
                                      element.weightList == 3 ||
                                      element.weightList == 4)
                                  .toList()
                                  .take(4)
                                  .map<Widget>((e) => Text(
                                        "${e.name} ${e.value}",
                                        style: TextStyle(
                                          color: Themes.text,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'IranSans',
                                        ),
                                      ))
                                  .toList() ??
                              [],
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
