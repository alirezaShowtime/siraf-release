import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:siraf3/bloc/chat/block/chat_block_bloc.dart';
import 'package:siraf3/bloc/chat/delete/chat_delete_bloc.dart';
import 'package:siraf3/bloc/chat/delete_message/chat_delete_message_bloc.dart';
import 'package:siraf3/bloc/chat/messages/messages_bloc.dart';
import 'package:siraf3/bloc/chat/search/messages/chat_message_box_search_status_bloc.dart';
import 'package:siraf3/bloc/chat/search/messages/request/chat_message_search_bloc.dart';
import 'package:siraf3/bloc/chat/select_message/select_message_bloc.dart';
import 'package:siraf3/bloc/chat/sendMessage/send_message_bloc.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/consultant_profile_without_comment/consultant_profile_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/confirm_dialog.dart';
import 'package:siraf3/widgets/my_app_bar.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';
import 'package:siraf3/widgets/text_field_2.dart';

import '../chat_massage_action.dart';

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
  bool showClearButton = false;

  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();

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
    return BlocBuilder(
      bloc: BlocProvider.of<ChatMessageBoxSearchStatusBloc>(context),
      builder: (_, bool isOpen) {
        return MyAppBar(
          automaticallyImplyLeading: false,
          elevation: defaultElevation,
          titleSpacing: 0,
          leading: MyBackButton(onPressed: () => onClickBackButton(isOpen)),
          title: isOpen ? searchBoxWidget() : title(),
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
            if (selectedCount <= 0 && !isOpen)
              BlocBuilder(
                bloc: BlocProvider.of<MessagesBloc>(context),
                builder: (context, state) {
                  if (state is! MessagesSuccess) return SizedBox();

                  return MyPopupMenuButton(
                    iconData: Icons.more_vert_rounded,
                    onSelected: (value) {
                      switch (value) {
                        case 0:
                          return toggleSearchBoxWidget();
                        case 1:
                          return deleteChat();
                        case 2:
                          return blockUser();
                      }
                    },
                    itemBuilder: (_) => [
                      MyPopupMenuItem(value: 0, label: "جستوجو", icon: CupertinoIcons.search),
                      MyPopupMenuItem(value: 1, label: "حذف چت", icon: CupertinoIcons.trash),
                      if (!isBlock) MyPopupMenuItem(value: 2, label: "مسدود کردن", icon: Icons.block),
                    ],
                  );
                },
              ),
            BlocBuilder(
              bloc: BlocProvider.of<ChatMessageSearchBloc>(context),
              builder: (context, state) {
                if (!isOpen) return SizedBox();

                if (state is ChatMessageSearchLoading) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: SpinKitRing(color: Themes.primary, size: 18, lineWidth: 3),
                  );
                }

                if (state is ChatMessageSearchError) {
                  IconButton(
                    onPressed: () => searchRequest(searchController.value.text),
                    icon: Icon(Icons.refresh_rounded, color: Themes.text),
                  );
                }

                if (showClearButton)
                  return IconButton(
                    onPressed: () {
                      searchController.clear();
                      showClearButton = false;
                      setState(() {});
                    },
                    icon: Icon(Icons.close_rounded, color: Themes.text),
                  );

                return SizedBox();
              },
            ),
          ],
        );
      },
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
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: const EdgeInsets.all(4),
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
    var ids = getSelectedIds();
    if (ids.isEmpty) return;

    confirmDeleteMessageDialog(
      context,
      onClickDelete: (bool isForAll) {
        BlocProvider.of<ChatDeleteMessageBloc>(context).add(
          ChatDeleteMessageRequestEvent(
            ids: ids,
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

    if (selecteds.where((e) => e.value == null).isNotEmpty) {
      var keys = selecteds.map((e) => e.key).toList();
      BlocProvider.of<ChatDeleteMessageBloc>(context).add(ChatDeleteMessageSendingEvent(keys));
      BlocProvider.of<SendMessageBloc>(context).add(SendMessageCancelEvent(keys));
      if (selecteds.where((e) => e.value != null).isEmpty) {
        BlocProvider.of<SelectMessageBloc>(context).add(SelectMessageClearEvent());
        return [];
      }
    }

    for (MapEntry selected in selecteds) {
      if (selected.value != null) {
        list.add(selected.value);
      }
    }
    return list;
  }

  Widget searchBoxWidget() {
    return TextField2(
      controller: searchController,
      focusNode: focusNode,
      maxLines: 1,
      onChanged: (text) {
        if (showClearButton != (text.length > 0)) {
          showClearButton = text.length > 0;
          setState(() {});
        }
      },
      onSubmitted: (text) {
        if (!text.isFill()) return;
        searchRequest(text);
      },
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "جستوجو...",
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
      style: TextStyle(
        fontFamily: "IranSansMedium",
        fontSize: 12,
      ),
    );
  }

  void toggleSearchBoxWidget() {
    setState(() {});
    BlocProvider.of<ChatMessageBoxSearchStatusBloc>(context).add(true);
  }

  void searchRequest(String text) {
    BlocProvider.of<ChatMessageSearchBloc>(context).add(ChatMessageSearchRequestEvent(chatId: widget.chatId!, q: text));
  }

  void onClickBackButton(bool isOpen) {
    if (selectedCount > 0) {
      BlocProvider.of<SelectMessageBloc>(context).add(SelectMessageClearEvent());
      return;
    }

    if (isOpen) {
      BlocProvider.of<ChatMessageBoxSearchStatusBloc>(context).add(false);
      BlocProvider.of<ChatMessageSearchBloc>(context).add(ChatMessageSearchCancelEvent());
      showClearButton = false;
      searchController.clear();
      setState(() {});
      return;
    }

    Navigator.pop(context, {
      "chatId": widget.chatId,
      "sentMessage": widget.lastMessage,
    });
  }
}
