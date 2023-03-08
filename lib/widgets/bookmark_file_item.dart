import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/bookmark.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/favorite_file.dart';
import 'package:siraf3/themes.dart';

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

    bookmark = Bookmark(id: widget.file.fileId!.id!, isFavorite: true, context: context);

    bookmark.favoriteStream.stream.listen((isFavorite) {
      if (!isFavorite) {
        widget.onRemoveFavorite(widget.file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = (MediaQuery.of(context).size.width - 20) / 3.5;
    if (imageSize > 140) imageSize = 140;
    return Container(
      decoration: BoxDecoration(
          color: App.theme.dialogBackgroundColor,
          boxShadow: [
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
            child: Stack(
              children: [
                Image(
                  image: NetworkImage(widget.file.fileId?.images?.first.path ?? ""),
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
                          widget.file.fileId!.getFirstPrice(),
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
                          widget.file.fileId!.getSecondPrice(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'IranSans',
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.file.fileId!.category!.getMainCategoryName().toString() + " | " + widget.file.fileId!.name!,
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
                          children: widget.file.fileId!.propertys
                                  ?.where((element) => element.weightList == 1 || element.weightList == 2 || element.weightList == 3 || element.weightList == 4)
                                  .take(4).toList()
                                  .map<Widget>((e) => Text(
                                        "${e.name} ${e.value}",
                                        style: TextStyle(
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
