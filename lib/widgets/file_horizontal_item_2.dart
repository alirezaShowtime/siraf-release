import 'package:flutter/material.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/widgets/my_image.dart';

class FileHorizontalItem2 extends StatefulWidget {
  File file;

  FileHorizontalItem2({required this.file, super.key});

  @override
  State<FileHorizontalItem2> createState() => _FileHorizontalItemState2();
}

class _FileHorizontalItemState2 extends State<FileHorizontalItem2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
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
      constraints: BoxConstraints(maxHeight: 140),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyImage(
            borderRadius: BorderRadius.circular(10),
            image: NetworkImage(widget.file.images?.first.path ?? ""),
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            loadingWidget: loadingImage(),
            errorWidget: loadingImage(),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      widget.file.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: App.theme.textTheme.bodyLarge?.color,
                        fontSize: 14,
                        fontFamily: 'IranSansBold',
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          widget.file.fullCategory!.name!,
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
                          (widget.file.publishedAgo ?? "") + ' | ' + (widget.file.city?.name ?? ""),
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      widget.file.getFirstPrice(),
                      style: TextStyle(
                        color: App.theme.textTheme.bodyLarge?.color,
                        fontSize: 14,
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
                          fontSize: 11,
                          fontFamily: 'IranSansMedium',
                        ),
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

  Widget loadingImage() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/siraf_logo.png",
            color: Colors.grey.shade300,
            scale: 8.5,
          ),
          SizedBox(height: 4),
          Image.asset(
            "assets/images/siraf_logo_text.png",
            color: Colors.grey.shade300,
            scale: 7,
          ),
        ],
      ),
    );
  }
}
