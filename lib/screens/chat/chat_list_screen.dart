import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:siraf3/bloc/chat/delete/chat_delete_bloc.dart';
import 'package:siraf3/bloc/chat/list/chat_list_bloc.dart';
import 'package:siraf3/bloc/chat/search/chat/chat_search_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/chat_item.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/chat/chat/chatScreen/chat_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/confirm_dialog.dart';
import 'package:siraf3/widgets/empty.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_app_bar.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';

class ChatListScreen extends StatefulWidget {
  @override
  State<ChatListScreen> createState() => _ChatListScreen();
}

class _ChatListScreen extends State<ChatListScreen> {
  ChatListBloc chatListBloc = ChatListBloc();
  ChatDeleteBloc chatDeleteBloc = ChatDeleteBloc();
  ChatSearchBloc chatSearchBloc = ChatSearchBloc();

  @override
  void initState() {
    super.initState();

    chatListBloc.add(ChatListRequestEvent());

    chatDeleteBloc.stream.listen((state) {
      if (state is ChatDeleteLoading) {
        loadingDialog(context: context);
        return;
      }
      if (state is ChatDeleteError) {
        dismissDialog(loadingDialogContext);
        errorDialog(context: context);
        return;
      }
      if (state is ChatDeleteSuccess) {
        dismissDialog(loadingDialogContext);
        chats.removeWhere((e) => selectedChats.any((element) => element.id == e.id));
        selectedChats = [];
        isSelectable = false;
        try {
          setState(() {});
        } catch (e) {}
      }
    });

    chatSearchBloc.stream.listen((state) {
      if (state is! ChatSearchSuccess) return;

      chats = state.chatItems;
      try {
        setState(() {});
      } catch (e) {}
    });

    listenRabbit();
  }

  List<ChatItem> chats = [];
  List<ChatItem> selectedChats = [];
  bool isSelectable = false;
  bool showSearchBoxWidget = false;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: App.getSystemUiOverlay(),
      child: BlocProvider(
        create: (_) => chatListBloc,
        child: WillPopScope(
          onWillPop: () async => _handleBack(),
          child: Scaffold(
            appBar: MyAppBar(
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
              systemOverlayStyle: App.getSystemUiOverlay(),
              title: showSearchBoxWidget ? searchBoxWidget() : AppBarTitle("لیست پیام ها"),
              actions: [
                if (!showSearchBoxWidget && selectedChats.isEmpty)
                  IconButton(
                    onPressed: () {
                      showSearchBoxWidget = !showSearchBoxWidget;
                      setState(() {});
                    },
                    icon: Icon(Icons.search_rounded),
                  ),
                BlocBuilder(
                  bloc: chatSearchBloc,
                  builder: (context, state) {
                    if (!showSearchBoxWidget || state is ChatSearchCancel) return SizedBox();

                    if (state is ChatSearchLoading) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: SpinKitRing(color: App.theme.primaryColor, size: 18, lineWidth: 3),
                      );
                    }

                    if (state is ChatSearchError) {
                      IconButton(
                        onPressed: () => searchRequest(searchController.value.text),
                        icon: Icon(Icons.refresh_rounded, color: App.theme.textTheme.bodyLarge?.color ?? Themes.text),
                      );
                    }

                    if (showClearButton)
                      return IconButton(
                        onPressed: () {
                          searchController.clear();
                          showClearButton = false;
                          setState(() {});
                        },
                        icon: Icon(Icons.close_rounded, color: App.theme.textTheme.bodyLarge?.color ?? Themes.text),
                      );

                    return SizedBox();
                  },
                ),
                if (selectedChats.isNotEmpty && !showSearchBoxWidget)
                  IconButton(
                    icon: Icon(CupertinoIcons.trash, size: 22),
                    onPressed: deleteChat,
                  ),
                if (!showSearchBoxWidget)
                  MyPopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        MyPopupMenuItem<int>(enable: selectedChats.length < chats.length, value: 0, label: "انتخاب همه"),
                        if (selectedChats.isNotEmpty) MyPopupMenuItem<int>(value: 1, label: "لغو انتخاب"),
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
            body: BlocConsumer<ChatListBloc, ChatListState>(
              builder: _listBlocBuilder,
              listener: (context, state) {
                if (state is! ChatListSuccess) return;
                chats = state.chatList;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget item(ChatItem chatItem) {
    bool isSelected = selectedChats.contains(chatItem);

    return Material(
      color: App.theme.dialogBackgroundColor,
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
          if (!isSelected && isSelectable && selectedChats.length > 0) {
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

          goToChatScreen(chatItem);
        },
        child: Container(
          height: 65,
          foregroundDecoration: !isSelected ? null : BoxDecoration(color: App.theme.primaryColor.withOpacity(0.1)),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: App.theme.dividerColor.withOpacity(0.3), width: 0.5),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Avatar(
                  image: (chatItem.isDeleted ? AssetImage("assets/images/deleted_chat.jpg") : NetworkImage(chatItem.consultantAvatar ?? "")) as ImageProvider,
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
                            color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                            fontFamily: "IranSansBold",
                          ),
                        ),
                        Expanded(
                          child: Text(
                            chatItem.fileTitle ?? "نامشخص",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
                              // fontFamily: "IranSansBold",
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      chatItem.isDeleted ? "چت توسط مشاور حذف شده" : chatItem.lastMessage ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: chatItem.isDeleted ? 10 : 11,
                        color: chatItem.isDeleted ? Colors.red : Colors.grey.shade500,
                        fontFamily: chatItem.isDeleted ? "IranSansBold" : "IranSans",
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
                      if (chatItem.isConsultant == false)
                        Icon(
                          (chatItem.isSeen ?? false) ? Icons.done_all_rounded : Icons.check_rounded,
                          color: App.theme.primaryColor,
                          size: 18,
                        ),
                      SizedBox(width: 4),
                      Text(
                        getChatTime(chatItem.createDate, chatItem.createTime),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 9,
                          height: 1,
                          fontFamily: "sans-serif",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (chatItem.countNotSeen != null && chatItem.countNotSeen! > 0 && !chatItem.isDeleted)
                    Container(
                      height: 20,
                      constraints: BoxConstraints(minWidth: 20),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: App.theme.primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        "${chatItem.countNotSeen!}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: "sans-serif",
                          fontWeight: FontWeight.w500,
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

    if (!chats.isNotNullOrEmpty()) return Center(child: Empty());

    return ListView(
      children: chats.map<Widget>((e) => item(e)).toList(),
    );
  }

  BuildContext? deleteDialogContext;

  FocusNode focusNode = FocusNode();
  bool showClearButton = false;

  _handleBack() {
    if (isSelectable) {
      setState(() {
        isSelectable = false;
        selectedChats.clear();
      });
      return false;
    }

    if (showSearchBoxWidget) {
      chatListBloc.add(ChatListRequestEvent());
      chatSearchBloc.add(ChatSearchCancelEvent());
      setState(() => showSearchBoxWidget = false);
      searchController.clear();
      return false;
    }

    rabbitClient?.close();

    return true;
  }

  String getChatTime(String? createDate, String? createTime) {
    if (createTime == null || createDate == null) return "";

    var nowDays = Jalali.now().day;

    var split = createDate.split("/");
    var days = int.parse(split[2]);
    var mouths = int.parse(split[1]);
    var years = int.parse(split[0]);

    if (nowDays == days) {
      return createTime;
    }

    var f = Jalali(years, mouths, days).formatter;
    return '${f.wN} ${f.d} ${f.mN} ${f.yy}';
  }

  void goToChatScreen(ChatItem chatItem) async {
    rabbitClient?.close();

    var result = await push(
        context,
        ChatScreen(
          chatId: chatItem.id!,
          consultantId: chatItem.consultantId,
          consultantImage: chatItem.consultantAvatar,
          consultantName: chatItem.consultantName,
          fileId: chatItem.fileId,
          fileTitle: chatItem.fileTitle,
          fileImage: chatItem.fileImage,
          blockByHer: chatItem.isBlockByHer,
          blockByMe: chatItem.isBlockByMe,
          isDeleted: chatItem.isDeleted,
          fileAddress: chatItem.fileAddress,
        ));

    listenRabbit();

    if (result is Map) {
      if (!result.containsKey("chatId") || chatItem.id != result["chatId"]) return;

      var index = chats.indexOf(chatItem);

      if (result.containsKey("deleted") && result["deleted"]) {
        chats.removeWhere((element) => element.id == chatItem.id);
        setState(() {});
        return;
      }
      if (result.containsKey("isBlockByMe")) {
        chatItem.isBlockByMe = result["isBlockByMe"];
      }

      if (result.containsKey("newMessageCount")) {
        chatItem.countNotSeen = result["newMessageCount"];
      }

      if (result.containsKey("sentMessage") && result["sentMessage"] != null) {
        chatItem.isConsultant = false;
        chatItem.lastMessage = result["sentMessage"];
      }
      chats[index] = chatItem;
    }

    setState(() {});
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
        searchRequest(text);
      },
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "جستجو...",
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
      style: TextStyle(
        fontFamily: "IranSansMedium",
        fontSize: 12,
        color: App.theme.textTheme.bodyLarge?.color,
      ),
    );
  }

  void deleteChat() {
    animationDialog(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        dialogContext: dialogContext,
        title: "حذف چت",
        content: "آیا واقعا می خواهید چت را حذف کنید؟",
        onApply: () {
          dismissDialog(dialogContext);
          chatDeleteBloc.add(ChatDeleteRequestEvent(selectedChats.map((e) => e.id!).toList(), true));
        },
      ),
    );
  }

  void searchRequest(String text) {
    chatSearchBloc.add(ChatSearchRequestEvent(text));
  }

  @override
  void dispose() {
    rabbitClient?.close();
    super.dispose();
  }

  Client? rabbitClient;

  void listenRabbit() async {
    rabbitClient = Client(settings: ConnectionSettings(host: "188.121.106.229", port: 5672, authProvider: PlainAuthenticator("admin", "admin")));

    Channel channel = await rabbitClient!.channel();
    var queueName = (await User.fromLocal()).id!.toString();
    Queue queue = await channel.queue(queueName);
    var consumer = await queue.consume(consumerTag: "app_user_chat_list");
    consumer.listen((AmqpMessage message) async {
      if (message.payloadAsJson['type'] == "new_message") {
        var list = chats.where((chat) => chat.id == message.payloadAsJson['data']['chat_id']);
        if (list.isEmpty) return;

        var chat = list.first;
        var chat_index = chats.indexWhere((e) => e.id == chat.id);

        var chatMessage = ChatMessage.fromJson(message.payloadAsJson['data']['message']);

        chats[chat_index].createDate = chatMessage.createDate;
        chats[chat_index].createTime = chatMessage.createTime;
        chats[chat_index].lastMessage = chatMessage.message;
        chats[chat_index].isSeen = false;
        chats[chat_index].countNotSeen = (chats[chat_index].countNotSeen ?? 0) + 1;

        setState(() {});
      }
    });
  }
}
