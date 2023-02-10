import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';

class AppBarChat extends AppBar {
  @override
  State<AppBar> createState() => _AppBarChat();

  void Function()? onclickRemoveChat;

  AppBarChat({required this.onclickRemoveChat});
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
          items: [
            popupMenuItemWithIcon(
              title: "حذف گفتگو",
              iconDate: CupertinoIcons.delete,
              onTap: () {
                widget.onclickRemoveChat?.call();
              },
            ),
          ],
        )
      ],
    );
  }

  Widget title() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: NetworkImage(
                      "https://www.seiu1000.org/sites/main/files/imagecache/hero/main-images/camera_lense_0.jpeg"),
                  width: 40,
                  height: 40,
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Image.asset(
                      "assets/images/profile.png",
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                left: 2,
                child: Container(
                  height: 9,
                  width: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "پشتیبانی",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Themes.text,
              ),
            ),
            Text(
              "آنلاین",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
