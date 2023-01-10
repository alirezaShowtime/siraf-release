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
      decoration: BoxDecoration(color: Themes.background, boxShadow: [
        BoxShadow(
          color: Themes.background2,
          blurRadius: 2,
          spreadRadius: 2,
          offset: Offset(0, -3),
        ),
      ]),
      padding: EdgeInsets.all(10),
      height: imageSize + 20,
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
                image: AssetImage("assets/images/1.jpg"),
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '300,000,000 ودیعه',
                            style: TextStyle(
                              color: Themes.text,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'BYekan',
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            '4,000,000 کرایه',
                            style: TextStyle(
                              color: Themes.text,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'BYekan',
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
                          fontFamily: 'BYekan',
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Center(
                    child: Text(
                      widget.file.name!,
                      style: TextStyle(
                        color: Themes.primary,
                        fontSize: 13.5,
                        fontFamily: 'BYekan',
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      Text(
                        '',
                        style: TextStyle(
                          color: Themes.text,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'BYekan',
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
                                .map<Widget>((e) => Text(
                                      "${e.name} ${e.value}",
                                      style: TextStyle(
                                        color: Themes.primary,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'BYekan',
                                      ),
                                    ))
                                .toList() ??
                            [],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
