import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/bookmark.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/dark_themes.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/location_file.dart';
import 'package:siraf3/themes.dart';
import 'package:flutter/material.dart' as m;
import 'package:siraf3/widgets/my_image.dart';

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

    bookmark = Bookmark(
        id: widget.locationFile.id!,
        isFavorite: widget.locationFile.favorite ?? false,
        context: context);

    bookmark.favoriteStream.stream.listen((fav) {
      setState(() {
        widget.locationFile.favorite = fav;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
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
      constraints: BoxConstraints(maxHeight: 120),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: MyImage(
              borderRadius: BorderRadius.circular(10),
              image: NetworkImage(widget.locationFile.image?.path ?? ""),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              loadingWidget: loadingImage(),
              errorWidget: loadingImage(),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.locationFile.name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: App.theme.textTheme.bodyLarge?.color,
                          fontSize: 14,
                          fontFamily: 'IranSansBold',
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.locationFile.category?.getMainCategoryName() ?? "",
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
                            (widget.locationFile.publishedAgo ?? "") + ' | ' + (widget.locationFile.city?.name ?? ""),
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.locationFile.getFirstPrice(),
                      style: TextStyle(
                        color: App.theme.textTheme.bodyLarge?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'IranSans',
                      ),
                    ),
                    SizedBox(height: 3),
                    if (widget.locationFile.getSecondPrice().isFill())
                      Text(
                        widget.locationFile.getSecondPrice(),
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
          m.Image.asset(
            "assets/images/siraf_logo.png",
            color: App.isDark ? DarkThemes.iconGrey : Colors.grey.shade300,
            scale: 8.5,
          ),
          SizedBox(height: 4),
          m.Image.asset(
            "assets/images/siraf_logo_text.png",
            color: App.isDark ? DarkThemes.iconGrey : Colors.grey.shade300,
            scale: 7,
          ),
        ],
      ),
    );
  }
}
