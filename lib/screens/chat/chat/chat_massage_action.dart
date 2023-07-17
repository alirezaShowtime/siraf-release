import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';

void showMessageActionMenu(
  BuildContext context,
  TapUpDetails details, {
  bool deletable = true,
  required bool isForMe,
  required void Function(bool isForMe) onClickDeleteItem,
  required void Function() onClickAnswerItem,
}) {
  showMenu<String>(
    context: context,
    constraints: BoxConstraints(minWidth: 180),
    elevation: 2,
    color: Colors.white,
    shadowColor: Colors.grey.shade200,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7),
    ),
    position: RelativeRect.fromLTRB(
      isForMe ? -10 : 10,
      details.globalPosition.dy,
      0.0,
      0.0,
    ),
    items: [
      MyPopupMenuItem(
        label: "پاسخ",
        icon: Icons.reply_rounded,
        onTap: onClickAnswerItem,
      ),
      MyPopupMenuItem(
        label: "حذف پیام",
        icon: CupertinoIcons.delete,
        onTap: () {
          Future.delayed(
            const Duration(seconds: 0),
            () => confirmDeleteMessageDialog(
              context,
              onClickDelete: (isForMe) => onClickDeleteItem.call(isForMe),
            ),
          );
        },
      ),
    ],
  );
}

void confirmDeleteMessageDialog(
  BuildContext context, {
  void Function(bool isForAll)? onClickDelete,
  void Function()? onClickCancel,
}) {
  bool isForAll = false;

  showDialog2(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "حذف پیام",
                    style: TextStyle(fontSize: 13, fontFamily: "IranSansBold"),
                  ),
                  Container(
                    height: 30,
                    padding: EdgeInsets.only(right: 10, top: 12),
                    child: Text(
                      "آیا واقعا می خواهید این پیام را حذف کنید?",
                      style: TextStyle(fontSize: 11, fontFamily: "IranSansMedium"),
                    ),
                  ),
                  SizedBox(height: 10),
                  StatefulBuilder(builder: (context, setState) {
                    return Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          value: isForAll,
                          onChanged: (bool? value) {
                            setState(() => isForAll = value ?? false);
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() => isForAll = !isForAll);
                          },
                          child: Text(
                            //todo consultant
                            "حذف برای مشاور",
                            style: TextStyle(fontSize: 10, fontFamily: "IranSansMedium"),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onClickDelete?.call(isForAll);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      color: Themes.primary,
                      elevation: 1,
                      height: 50,
                      child: Text(
                        "تایید",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 9),
                    ),
                  ),
                  VerticalDivider(width: 0.3, color: Themes.primary.withAlpha(60)),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onClickCancel?.call();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      color: Themes.primary,
                      elevation: 1,
                      height: 50,
                      child: Text(
                        "لغو",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
