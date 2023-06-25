import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/models/chat_item.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';

class AppBarChat extends AppBar {
  @override
  State<AppBar> createState() => _AppBarChat();

  ChatItem chatItem;

  AppBarChat({required this.chatItem});
}

class _AppBarChat extends State<AppBarChat> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: defaultElevation,
      titleSpacing: 0,
      leading: MyBackButton(),
      title: title(),
      actions: [
        MyPopupMenuButton(
          iconData: Icons.more_vert_rounded,
          itemBuilder: (_) => [
            MyPopupMenuItem(
              label: "حذف گفتوگو",
              icon: CupertinoIcons.trash,
            ),
          ],
        ),
      ],
    );
  }

  Widget title() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Avatar(
            imagePath: widget.chatItem.consultantAvatar ?? "",
            size: 40,
            errorImage: AssetImage("assets/images/profile.jpg"),
            loadingImage: AssetImage("assets/images/profile.jpg"),
          ),
        ),
        Expanded(
          child: Text(
            widget.chatItem.consultantName ?? "مشاور",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Themes.themeData().textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ],
    );
  }
}
