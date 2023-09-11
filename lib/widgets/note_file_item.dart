import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/bookmark.dart';
import 'package:siraf3/dark_themes.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/note.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_image.dart';

class NoteFileItem extends StatefulWidget {
  Note note;
  bool isSelected;
  void Function(Note) onRemoveFavorite;

  NoteFileItem({
    required this.note,
    required this.isSelected,
    required this.onRemoveFavorite,
    super.key,
  });

  @override
  State<NoteFileItem> createState() => _NoteFileItemState();
}

class _NoteFileItemState extends State<NoteFileItem> {
  late Bookmark bookmark;

  @override
  void initState() {
    super.initState();

    bookmark = Bookmark(id: widget.note.fileId!.id!, isFavorite: true, context: context);

    bookmark.favoriteStream.stream.listen((isFavorite) {
      if (!isFavorite) {
        widget.onRemoveFavorite(widget.note);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    MyImage(
                      borderRadius: BorderRadius.circular(10),
                      image: widget.note.fileId!.images.isFill() ? NetworkImage(widget.note.fileId?.images?.first.path ?? "") : NetworkImage(""),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      withSaveState: true,
                      loadingWidget: loadingImage(),
                      errorWidget: loadingImage(),
                    ),
                    Positioned(
                      right: 6,
                      top: -1,
                      child: GestureDetector(
                        onTap: () {
                          bookmark.addOrRemoveFavorite(withNote: true, noteId: widget.note.id);
                        },
                        child: Icon(
                          CupertinoIcons.bookmark_fill,
                          color: App.theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            widget.note.fileId!.name!,
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
                                widget.note.fileId!.category?.getMainCategoryName() ?? "",
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
                                (widget.note.fileId!.publishedAgo ?? "") + ' | ' + (widget.note.fileId!.city?.name ?? ""),
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
                          widget.note.fileId!.getFirstPrice(),
                          style: TextStyle(
                            color: App.theme.textTheme.bodyLarge?.color,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IranSans',
                          ),
                        ),
                        SizedBox(height: 3),
                        if (widget.note.fileId!.getSecondPrice().isFill())
                          Text(
                            widget.note.fileId!.getSecondPrice(),
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
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "یادداشت : ",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "IranSansMedium",
                    color: App.theme.primaryColor,
                  ),
                ),
                TextSpan(
                  text: widget.note.note ?? "",
                  style: TextStyle(
                    fontSize: 13,
                    color: App.theme.textTheme.bodyLarge?.color,
                    fontFamily: "IranSansMedium",
                  ),
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
