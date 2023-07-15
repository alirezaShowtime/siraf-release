import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/chat/select_message/select_message_bloc.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';

class AppBarChat extends AppBar {
  @override
  State<AppBar> createState() => _AppBarChat();

  String? consultantName;
  String? consultantImage;
  int? consultantId;
  int? chatId;
  String? lastMessage;

  AppBarChat({
    this.consultantName,
    this.consultantImage,
    this.consultantId,
    this.chatId,
    this.lastMessage,
  });
}

class _AppBarChat extends State<AppBarChat> {
  int selectedCount = 0;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<SelectMessageBloc>(context).stream.listen((state) {
      try {
        if (state is SelectMessageCountSate) {
          setState(() => selectedCount = state.count);
        }
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: defaultElevation,
      titleSpacing: 0,
      leading: MyBackButton(
        onPressed: () {
          if (selectedCount > 0) {
            BlocProvider.of<SelectMessageBloc>(context).add(SelectMessageClearEvent());
            return;
          }

          Navigator.pop(context, {
            "chatId": widget.chatId,
            "sentMessage": widget.lastMessage,
          });
        },
      ),
      title: title(),
      actions: [
        if (selectedCount > 0)
          Padding(
            padding: const EdgeInsets.only(left: 7),
            child: IconButton(
              onPressed: deleteMessages,
              icon: Icon(
                CupertinoIcons.delete,
                size: 22,
              ),
            ),
          ),
        if (selectedCount <= 0)
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
            imagePath: widget.consultantImage ?? "",
            size: 40,
            errorImage: AssetImage("assets/images/profile.jpg"),
            loadingImage: AssetImage("assets/images/profile.jpg"),
          ),
        ),
        Expanded(
          child: Text(
            widget.consultantName ?? "مشاور",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Themes.themeData().textTheme.bodyLarge?.color,
            ),
          ),
        ),
        if (selectedCount > 0)
          Padding(
            padding: const EdgeInsets.only(left: 7),
            child: Text(
              selectedCount.toString(),
              style: TextStyle(
                color: Themes.text,
                fontFamily: "IranSansBold",
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  //todo
  void deleteMessages() {}
}
