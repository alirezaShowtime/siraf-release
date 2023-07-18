import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/chat/block/chat_block_bloc.dart';
import 'package:siraf3/bloc/chat/delete/chat_delete_bloc.dart';
import 'package:siraf3/bloc/chat/delete_message/chat_delete_message_bloc.dart';
import 'package:siraf3/bloc/chat/select_message/select_message_bloc.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/consultant_profile/consultant_profile_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/confirm_dialog.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';

import 'chat_massage_action.dart';

class AppBarChat extends AppBar {
  @override
  State<AppBar> createState() => _AppBarChat();

  String? consultantName;
  String? consultantImage;
  int? consultantId;
  int? chatId;
  String? lastMessage;
  bool isDisable;

  AppBarChat({
    this.consultantName,
    this.consultantImage,
    this.consultantId,
    this.chatId,
    this.lastMessage,
    this.isDisable = false,
  });
}

class _AppBarChat extends State<AppBarChat> {
  int selectedCount = 0;
  bool isBlock = false;

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

    BlocProvider.of<ChatBlockBloc>(context).stream.listen((state) {
      try {
        if (state is ChatBlockSuccess) {
          setState(() => isBlock = state.isBlock);
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
          IconButton(
            onPressed: deselectMessage,
            icon: Text(
              "لغو",
              style: TextStyle(
                fontSize: 11,
                fontFamily: "IranSansBold",
              ),
            ),
          ),
        if (selectedCount > 0)
          Padding(
            padding: const EdgeInsets.only(left: 7),
            child: IconButton(
              onPressed: deleteMessages,
              icon: Icon(CupertinoIcons.delete, size: 22),
            ),
          ),
        if (selectedCount <= 0)
          MyPopupMenuButton(
            iconData: Icons.more_vert_rounded,
            onSelected: (value) {
              switch (value) {
                case 0:
                  return deleteChat();
                case 1:
                  return blockUser();
              }
            },
            itemBuilder: (_) => [
              MyPopupMenuItem(value: 0, label: "حذف چت", icon: CupertinoIcons.trash),
              if (!isBlock) MyPopupMenuItem(value: 1, label: "مسدود کردن", icon: Icons.block),
            ],
          ),
      ],
    );
  }

  Widget title() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            if (widget.consultantId != null) {
              push(context, ConsultantProfileScreen(consultantId: widget.consultantId!, consultantName: widget.consultantName));
            }
          },
          // borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: const EdgeInsets.all(4),
            // constraints: BoxConstraints(minWidth: 100),
            child: Row(
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
                Text(
                  widget.consultantName ?? "مشاور",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "IranSansBold",
                    color: Themes.themeData().textTheme.bodyLarge?.color,
                  ),
                ),
              ],
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
              ),
            ),
          ),
      ],
    );
  }

  void deleteMessages() {
    confirmDeleteMessageDialog(
      context,
      onClickDelete: (bool isForAll) {
        BlocProvider.of<ChatDeleteMessageBloc>(context).add(
          ChatDeleteMessageRequestEvent(
            ids: getSelectedIds(),
            isForAll: isForAll,
            chatId: widget.chatId!,
          ),
        );
      },
    );
  }

  void blockUser() {
    animationDialog(
      context: context,
      builder: (dialogContext) {
        return ConfirmDialog(
          dialogContext: dialogContext,
          title: "مسدود کردن",
          content: "آیا واقعا قصد مسدود کردن کاربر را دارید؟",
          onApply: () {
            dismissDialog(dialogContext);
            BlocProvider.of<ChatBlockBloc>(context).add(ChatBlockRequestEvent([widget.chatId!], true));
          },
        );
      },
    );
  }

  void deleteChat() {
    animationDialog(
      context: context,
      builder: (dialogContext) {
        return ConfirmDialog(
          dialogContext: dialogContext,
          title: "حذف کردن",
          content: "آیا واقعا قصد حذف کردن چت را دارید؟",
          onApply: () {
            dismissDialog(dialogContext);
            BlocProvider.of<ChatDeleteBloc>(context).add(ChatDeleteRequestEvent([widget.chatId!], true));
          },
        );
      },
    );
  }

  void deselectMessage() {
    BlocProvider.of<SelectMessageBloc>(context).add(SelectMessageClearEvent());
  }

  List<int> getSelectedIds() {
    List<int> list = [];

    var selecteds = BlocProvider.of<SelectMessageBloc>(context).selectedMessages;
    print(selecteds);

    for (MapEntry selected in selecteds) {
      list.add(selected.value);
    }
    return list;
  }
}
