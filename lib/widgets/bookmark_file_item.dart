import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/bookmark.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/favorite_file.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_image.dart';

class BookmarkFileItem extends StatefulWidget {
  FavoriteFile file;
  bool isSelected;
  void Function(FavoriteFile file) onRemoveFavorite;

  BookmarkFileItem({
    required this.file,
    required this.isSelected,
    required this.onRemoveFavorite,
    super.key,
  });

  @override
  State<BookmarkFileItem> createState() => _BookmarkFileItemState();
}

class _BookmarkFileItemState extends State<BookmarkFileItem> {
  late Bookmark bookmark;

  @override
  void initState() {
    super.initState();

    bookmark = Bookmark(
        id: widget.file.fileId!.id!, isFavorite: true, context: context);

    bookmark.favoriteStream.stream.listen((isFavorite) {
      if (!isFavorite) {
        widget.onRemoveFavorite(widget.file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
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
      constraints: BoxConstraints(maxHeight: 120),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                MyImage(
                  borderRadius: BorderRadius.circular(10),
                  image: widget.file.fileId!.images.isFill() ? NetworkImage(widget.file.fileId?.images?.first.path ?? "") : NetworkImage(""),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  loadingWidget: loadingImage(),
                  errorWidget: loadingImage(),
                ),
                Positioned(
                  right: 6,
                  top: -1,
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
                        widget.file.fileId!.name!,
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
                            widget.file.fileId!.category?.getMainCategoryName() ?? "",
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
                            (widget.file.fileId!.publishedAgo ?? "") + ' | ' + (widget.file.fileId!.city ?? ""),
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
                      widget.file.fileId!.getFirstPrice(),
                      style: TextStyle(
                        color: App.theme.textTheme.bodyLarge?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'IranSans',
                      ),
                    ),
                    SizedBox(height: 3),
                    if (widget.file.fileId!.getSecondPrice().isFill())
                      Text(
                        widget.file.fileId!.getSecondPrice(),
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
