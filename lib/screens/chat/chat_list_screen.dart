import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/chat/list/chat_list_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/chat_item.dart';
import 'package:siraf3/screens/chat/chat/chat_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/empty.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_icon_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';
import 'package:siraf3/widgets/try_again.dart';

class ChatListScreen extends StatefulWidget {
  @override
  State<ChatListScreen> createState() => _ChatListScreen();
}

class _ChatListScreen extends State<ChatListScreen> {
  ChatListBloc chatListBloc = ChatListBloc();

  @override
  void initState() {
    super.initState();

    chatListBloc.add(ChatListRequestEvent());
  }

  List<ChatItem> chats = [];
  List<ChatItem> selectedChats = [];
  bool isSelectable = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => chatListBloc,
      child: WillPopScope(
        onWillPop: () async => _handleBack(),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.7,
            titleSpacing: 0,
            leading: MyBackButton(
              onPressed: () {
                if (_handleBack()) {
                  Navigator.pop(context);
                }
              },
            ),
            title: AppBarTitle("لیست پیام ها"),
            actions: [
              if (selectedChats.isNotEmpty)
                MyIconButton(
                  iconData: CupertinoIcons.trash,
                  onTap: () {},
                ),
              MyPopupMenuButton(
                itemBuilder: (context) {
                  return [
                    MyPopupMenuItem<int>(enable: selectedChats.length < chats.length, value: 0, label: "انتخاب همه"),
                    if (selectedChats.isNotEmpty) MyPopupMenuItem<int>(value: 1, label: "لغو انتخاب همه"),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    setState(() {
                      selectedChats.clear();
                      selectedChats.addAll(chats);
                      isSelectable = true;
                    });
                  }
                  if (value == 1) {
                    setState(() {
                      selectedChats.clear();
                      isSelectable = false;
                    });
                  }
                },
                iconData: Icons.more_vert,
              ),
            ],
          ),
          body: BlocBuilder<ChatListBloc, ChatListState>(builder: _listBlocBuilder),
        ),
      ),
    );
  }

  Widget item(ChatItem chatItem) {
    bool isSelected = selectedChats.contains(chatItem);

    return Material(
      color: Colors.white,
      child: InkWell(
        onLongPress: () {
          if (!isSelected) {
            setState(() {
              selectedChats.add(chatItem);
              isSelectable = true;
            });
            return;
          }
        },
        onTap: () {
          if (!isSelected && isSelectable) {
            setState(() {
              selectedChats.add(chatItem);
            });
            return;
          }
          if (isSelected) {
            setState(() {
              selectedChats.remove(chatItem);
            });
            return;
          }

          push(context, ChatScreen(chatItem: chatItem));
        },
        child: Container(
          height: 65,
          foregroundDecoration: !isSelected ? null : BoxDecoration(color: Themes.primary.withOpacity(0.1)),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.black12, width: 0.5),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Avatar(
                  imagePath: chatItem.consultantAvatar ?? "",
                  size: 50,
                  errorImage: AssetImage("assets/images/profile.jpg"),
                  loadingImage: AssetImage("assets/images/profile.jpg"),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${chatItem.consultantName ?? "مشاور"} | ",
                          style: TextStyle(
                            fontSize: 12,
                            color: Themes.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            chatItem.fileTitle ?? "نامشخص",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Themes.textGrey,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      chatItem.message?.type == "file " ? "سند" : (chatItem.message?.message ?? ""),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        height: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (chatItem.message?.isConsultant == false)
                        Icon(
                          chatItem.message!.isSeen! ? Icons.done_all_rounded : Icons.check_rounded,
                          color: App.theme.primaryColor,
                          size: 18,
                        ),
                      SizedBox(width: 4),
                      Text(
                        chatItem.message?.timeAgo ?? "",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 9, height: 1),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (chatItem.message?.countUnseen != null && chatItem.message!.countUnseen! > 0 && chatItem.message?.isConsultant == true)
                    Container(
                      height: 20,
                      constraints: BoxConstraints(minWidth: 20),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Themes.primary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        "${chatItem.message!.countUnseen!}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: "IranSansMedium",
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listBlocBuilder(BuildContext context, ChatListState state) {
    if (state is ChatListInitial) return Container();

    if (state is ChatListLoading) return Center(child: Loading());

    if (state is ChatListError) {
      return Center(
        child: TryAgain(
          message: state.message,
          onPressed: () => chatListBloc.add(ChatListRequestEvent()),
        ),
      );
    }

    chats = (state as ChatListSuccess).chatList;

    if (!chats.isNotNullOrEmpty()) return Center(child: Empty());

    return ListView(
      children: chats.map<Widget>((e) => item(e)).toList(),
    );
  }

  BuildContext? deleteDialogContext;

  _handleBack() {
    if (isSelectable) {
      setState(() {
        isSelectable = false;
        selectedChats.clear();
      });
      return false;
    }
    return true;
  }
}
