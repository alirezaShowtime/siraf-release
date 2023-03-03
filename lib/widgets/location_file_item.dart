import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/bookmark.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/location_file.dart';
import 'package:siraf3/themes.dart';
import 'package:flutter/material.dart' as m;

class LocationFileItem extends StatefulWidget {
  LocationFile locationFile;
  LocationFileItem({required this.locationFile, Key? key}) : super(key: key);

  @override
  State<LocationFileItem> createState() => _LocationFileItemState();
}

class _LocationFileItemState extends State<LocationFileItem> {
  late Bookmark bookmark;

  @override
  void initState() {
    super.initState();

    bookmark = Bookmark(id: widget.locationFile.id!, isFavorite: widget.locationFile.favorite ?? false, context: context);
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = (MediaQuery.of(context).size.width - 20) / 3.5;
    if (imageSize > 140) imageSize = 140;
    return Container(
      decoration: BoxDecoration(
        color: Themes.background2,
        boxShadow: [
          BoxShadow(
            color: Themes.textGrey.withOpacity(0.1),
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Themes.textGrey.withOpacity(0.1),
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(1, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(10),
      constraints: BoxConstraints(maxHeight: 160),
      width: double.infinity,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                m.Image(
                  image: NetworkImage(widget.locationFile.image?.path ?? ""),
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => m.Image(
                    image: AssetImage("assets/images/image_not_avialable_2.png"),
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      bookmark.addOrRemoveFavorite();
                    },
                    child: Icon(
                      CupertinoIcons.bookmark_fill,
                      color: Themes.primary,
                    ),
                  ),
                ),
              ],
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          number_format(125600000),
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
                          number_format(358000000),
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
                      "فروشی | آپارتمان فروشی تهران",
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: widget.file.fileId!.propertys
                        //           ?.where((element) => element.weightList == 1 || element.weightList == 2 || element.weightList == 3 || element.weightList == 4)
                        //           .toList()
                        //           .map<Widget>((e) => Text(
                        //                 "${e.name} ${e.value}",
                        //                 style: TextStyle(
                        //                   color: Themes.text,
                        //                   fontSize: 10.5,
                        //                   fontWeight: FontWeight.w400,
                        //                   fontFamily: 'IranSans',
                        //                 ),
                        //               ))
                        //           .toList() ??
                        //       [],
                        // ),
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
