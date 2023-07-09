import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_alert_dialog.dart';
import 'package:siraf3/widgets/my_content_dialog.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/title_dialog.dart';

void showMessageActionMenu(
  BuildContext context,
  TapUpDetails details, {
  required void Function() onClickDeleteItem,
  required void Function() onClickAnswerItem,
}) {
  showMenu<String>(
    context: context,
    constraints: BoxConstraints(minWidth: 180),
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7),
    ),
    position: RelativeRect.fromLTRB(
      details.globalPosition.dx,
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
            () => confirmDeleteMessageDialog(context, isForMe: true, onClickDelete: onClickDeleteItem),
          );
        },
      ),
    ],
  );
}

//todo: checkbox is not working, please check it
void confirmDeleteMessageDialog(
  BuildContext context, {
  bool isForMe = false,
  String? userName,
  Function(bool?)? onChangeDeleteForAll,
  void Function()? onClickDelete,
  void Function()? onClickCancel,
}) {
  bool isChecked = false;

  showDialog2(
    context: context,
    builder: (context) {
      return MyAlertDialog(
        actions: [
          MyTextButton(
            text: "حذف",
            onPressed: () {
              Navigator.pop(context);
              onClickDelete?.call();
            },
            rippleColor: Colors.red,
            textColor: Colors.red,
          ),
          MyTextButton(
            text: "لغو",
            onPressed: () {
              Navigator.pop(context);

              onClickCancel?.call();
            },
            textColor: Themes.primary,
          ),
        ],
        title: TitleDialog(title: "حذف پیام"),
        content: SizedBox(
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyContentDialog(content: "آیا واقعا می خواهید این پیام را حذف کنید?"),
              if (isForMe) SizedBox(height: 10),
              if (isForMe)
                Row(
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      value: isChecked,
                      onChanged: (bool? value) {
                        isChecked = value ?? false;
                        onChangeDeleteForAll?.call(value);
                      },
                    ),
                    Text(
                      "حذف برای $userName",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                )
            ],
          ),
        ),
      );
    },
  );
}
