import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:siraf3/bloc/chat/block/chat_block_bloc.dart';
import 'package:siraf3/bloc/chat/delete/chat_delete_bloc.dart';
import 'package:siraf3/bloc/chat/delete_message/chat_delete_message_bloc.dart';
import 'package:siraf3/bloc/chat/messages/messages_bloc.dart';
import 'package:siraf3/bloc/chat/pagination/chat_screen_pagination_bloc.dart';
import 'package:siraf3/bloc/chat/play/voice_message_play_bloc.dart';
import 'package:siraf3/bloc/chat/recordingVoice/recording_voice_bloc.dart';
import 'package:siraf3/bloc/chat/reply/chat_reply_bloc.dart';
import 'package:siraf3/bloc/chat/search/messages/chat_message_box_search_status_bloc.dart';
import 'package:siraf3/bloc/chat/search/messages/request/chat_message_search_bloc.dart';
import 'package:siraf3/bloc/chat/seen/seen_message_bloc.dart';
import 'package:siraf3/bloc/chat/select_message/select_message_bloc.dart';
import 'package:siraf3/bloc/chat/sendMessage/send_message_bloc.dart';
import 'package:siraf3/controller/chat_message_upload_controller.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/chat/chat/abstract_message_widget.dart';
import 'package:siraf3/screens/chat/chat/chatScreen/app_bar_chat_widget.dart';
import 'package:siraf3/screens/chat/chat/chat_message_editor_widget.dart';
import 'package:siraf3/screens/chat/chat/found_message_widget_index.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_icon_button.dart';
import 'package:siraf3/widgets/my_image.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/try_again.dart';

import '../messageWidgets/chat_message_widget.dart';
import '../message_widget_list.dart';
import '../sendingMessageWidgets/chat_sending_message_widget.dart';

import 'package:siraf3/main.dart';

part 'bloc_listeners.dart';
part 'chat_message_search.dart';
part 'chat_scroll_controller.dart';
part 'header_widget.dart';
part 'voice_recorder.dart';
part 'rabbit_listener.dart';

class ChatScreen extends StatefulWidget {
  String? consultantName;
  String? consultantImage;
  int? consultantId;
  String? fileTitle;
  String? fileImage;
  String? fileAddress;
  int? fileId;
  int chatId;
  bool blockByMe;
  bool blockByHer;
  bool isDeleted;

  ChatScreen({
    required this.chatId,
    this.consultantName,
    this.consultantImage,
    this.consultantId,
    this.fileTitle,
    this.fileImage,
    this.fileAddress,
    this.fileId,
    this.blockByMe = false,
    this.blockByHer = false,
    this.isDeleted = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ChatScreen> {
  @override
  bool get wantKeepAlive => true;

  MessagesBloc chatMessagesBloc = MessagesBloc();
  final SendMessageBloc sendMessageBloc = SendMessageBloc();
  final SeenMessageBloc seenMessageBloc = SeenMessageBloc();
  final ChatReplyBloc chatReplyBloc = ChatReplyBloc();
  final RecordingVoiceBloc recordingVoiceBloc = RecordingVoiceBloc();
  final VoiceMessagePlayBloc voiceMessagePlayBloc = VoiceMessagePlayBloc();
  final SelectMessageBloc selectMessageBloc = SelectMessageBloc();
  final ChatBlockBloc chatBlockBloc = ChatBlockBloc();
  final ChatDeleteBloc chatDeleteBloc = ChatDeleteBloc();
  final ChatDeleteMessageBloc chatDeleteMessageBloc = ChatDeleteMessageBloc();
  final ChatMessageBoxSearchStatusBloc chatSearchBoxMessageStatus = ChatMessageBoxSearchStatusBloc();
  final ChatMessageSearchBloc chatMessageSearchBloc = ChatMessageSearchBloc();
  final ChatScreenPaginationBloc chatScreenPaginationBloc = ChatScreenPaginationBloc();

  final double begin_floatingActionButtonOffset = -100;
  final double end_floatingActionButtonOffset = 10;

  late AnimationController _scrollDownAnimationController;
  late Animation<double> _scrollDownAnimation;

  List<ChatMessage> messages = [];

  late AnimationController voiceAnimController;
  late Animation<double> voiceAnim;
  late Animation<double> recordIconAnim;
  Timer? scrollDownButtonTimer;

  MessageWidgetList messageWidgets = MessageWidgetList();

  bool isRecording = false;
  void Function(void Function())? listViewSetState = null;
  void Function(void Function())? fileListSetState = null;

  Timer? timer;
  int recordTime = 0;

  StreamController<int> recordTimeStream = StreamController.broadcast();

  ChatMessage? lastMessage;

  late bool isBlockByMe;
  late bool blockByHer;
  late bool isDeleted;

  final Record _audioRecorder = Record();

  ChatMessage? replyMessage;

  bool isOpenEmojiKeyboard = false;
  bool showSearchResult = false;

  int countSearch = 0;

  bool hasPreviousMessage = true;
  bool hasNextMessage = false;

  StreamController<bool> changeEmojiKeyboardStatus = StreamController.broadcast();

  final ItemScrollController chatItemScrollController = ItemScrollController();
  final ScrollOffsetController chatScrollOffsetController = ScrollOffsetController();

  FoundMessageWidgetIndexes foundMessageWidgetIndexes = FoundMessageWidgetIndexes();

  int? currentFoundedIndex;

  int newMessageCount = 0;

  var newMessageCountBadgeSetState;

  Client? rabbitClient;

  @override
  void initState() {
    super.initState();

    isBlockByMe = widget.blockByMe;
    blockByHer = widget.blockByHer;
    isDeleted = widget.isDeleted;

    voiceAnimController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    voiceAnim = Tween<double>(begin: 0, end: 5).animate(voiceAnimController..repeat(reverse: true));
    recordIconAnim = Tween<double>(begin: 0.7, end: 1.0).animate(voiceAnimController..repeat(reverse: true));

    initScrollAnimation();

    _request();

    chatMessageSearchBlocListener();

    deleteMessageBlocListener();

    chatReplyBlocListener();

    recordingVoiceBlocListener();

    chatMessagesBlocListener();

    sendMessageBlocListener();

    chatBlockBlocListener();

    chatDeleteBlocListener();

    paginationBlocListener();

    listenRabbit();
  }

  @override
  void dispose() {
    recordingVoiceBloc.close();
    voiceMessagePlayBloc.close();
    selectMessageBloc.close();
    chatMessagesBloc.close();
    voiceAnimController.dispose();
    chatBlockBloc.close();
    chatDeleteBloc.close();
    recordTimeStream.close();
    _audioRecorder.dispose();
    chatDeleteMessageBloc.close();
    rabbitClient?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => chatMessagesBloc),
        BlocProvider(create: (_) => sendMessageBloc),
        BlocProvider(create: (_) => seenMessageBloc),
        BlocProvider(create: (_) => chatReplyBloc),
        BlocProvider(create: (_) => voiceMessagePlayBloc),
        BlocProvider(create: (_) => selectMessageBloc),
        BlocProvider(create: (_) => chatBlockBloc),
        BlocProvider(create: (_) => chatDeleteBloc),
        BlocProvider(create: (_) => recordingVoiceBloc),
        BlocProvider(create: (_) => chatDeleteMessageBloc),
        BlocProvider(create: (_) => chatSearchBoxMessageStatus),
        BlocProvider(create: (_) => chatMessageSearchBloc),
      ],
      child: WillPopScope(
        onWillPop: onClickBackButton(),
        child: KeyboardSizeProvider(
          smallSize: 400,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: App.getSystemUiOverlay(),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBarChat(
                consultantId: widget.consultantId,
                consultantName: widget.consultantName,
                consultantImage: widget.consultantImage,
                chatId: widget.chatId,
                isDisable: blockByHer || isBlockByMe,
                onClickBackButton: backToList,
              ),
              body: Stack(
                children: [
                  BlocConsumer(
                    bloc: chatMessagesBloc,
                    listener: (context, state) {
                      if (state is! MessagesSuccess) return;
                      messages = state.messages;
          
                      try {
                        lastMessage = messages.last;
                      } catch (e) {}
          
                      for (ChatMessage message in messages) {
                        messageWidgets.add(
                          createDate: message.createDate!,
                          widget: ChatMessageWidget(
                            messageKey: MessageWidgetKey(message),
                            message: message,
                            onClickReplyMessage: scrollTo,
                          ),
                        );
                      }
                      if (messages.isFill() && !messages.last.forMe) {
                        seenMessageBloc.add(SeenMessageRequestEvent(widget.chatId));
                      }
                    },
                    builder: (context, state) {
                      if (state is MessagesInitial) return Container();
          
                      if (state is MessagesLoading) return Align(alignment: Alignment.center, child: Container(alignment: Alignment.center, child: Loading()));
          
                      if (state is MessagesError) {
                        return Center(child: TryAgain(onPressed: _request, message: state.message));
                      }
          
                      bool isEmptyMessageWidgets = messageWidgets.widgetLength() == 0;
          
                      return Column(
                        children: [
                          headerChatWidget(),
                          Expanded(
                            child: Stack(
                              children: [
                                if (isEmptyMessageWidgets)
                                  const Center(
                                    child: Text(
                                      "پیامی وجود ندارد",
                                      style: TextStyle(
                                        fontFamily: "IranSansBold",
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                if (!isEmptyMessageWidgets)
                                  StatefulBuilder(builder: (context, setState) {
                                    listViewSetState = setState;
          
                                    var list = generateList();
          
                                    return NotificationListener(
                                      onNotification: onNotificationListView,
                                      child: ScrollablePositionedList.builder(
                                        reverse: true,
                                        itemCount: list.length,
                                        itemBuilder: (_, i) => list[i],
                                        addAutomaticKeepAlives: true,
                                        itemScrollController: chatItemScrollController,
                                        scrollOffsetController: chatScrollOffsetController,
                                      ),
                                    );
                                  }),
                                if (!isEmptyMessageWidgets) ScrollDownButtonWidget(),
                              ],
                            ),
                          ),
                          BlocBuilder(
                            bloc: chatSearchBoxMessageStatus,
                            builder: (context, bool state) {
                              if (state) return searchControllerWidget();
                              if (isDeleted) return notifChatWidget("حذف شده");
                              if (isBlockByMe) return notifChatWidget("رفع مسدودیت", onTap: onClickUnblock);
                              if (blockByHer && !isBlockByMe) return notifChatWidget("شما مسدود شداید");
                              if (!isBlockByMe && !isDeleted && !blockByHer)
                                return ChatMessageEditor(
                                  onClickSendMessage: sendMessage,
                                  changeKeyboardStatus: changeEmojiKeyboardStatus,
                                  onOpenEmojiKeyboard: (isOpen) {
                                    isOpenEmojiKeyboard = isOpen;
                                  },
                                );
                              return SizedBox();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  VoiceRecorderWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> generateList() {
    List<Widget> newList = messageWidgets.getList().reversed.toList();
    newList.add(SizedBox(height: 10));
    newList.insert(0, SizedBox(height: 10));

    if (hasPreviousMessage) {
      newList.add(BlocBuilder(
        bloc: chatScreenPaginationBloc,
        builder: (_, state) {
          if (state is! ChatScreenPaginationLoading) return SizedBox();
          return paginationLoadingWidget();
        },
      ));
    }
    if (hasNextMessage) {
      newList.insert(
          1,
          BlocBuilder(
            bloc: chatScreenPaginationBloc,
            builder: (_, state) {
              if (state is! ChatScreenPaginationLoading) return SizedBox();
              return paginationLoadingWidget();
            },
          ));
    }

    return newList;
  }

  Widget notifChatWidget(String s, {void Function()? onTap}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 55,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300, width: 0.7)),
          ),
          child: Text(
            s,
            style: TextStyle(
              color: Colors.red,
              fontFamily: "IranSansBold",
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  void _request() {
    chatMessagesBloc.add(MessagesRequestEvent(id: widget.chatId));
  }

  void sendMessage(String? text, List<File>? files, ChatMessage? reply) {
    ChatMessageUploadController messageUploadController = ChatMessageUploadController();

    ChatSendingMessageWidget sendingMessageWidget = ChatSendingMessageWidget(
      messageKey: MessageWidgetKey(null),
      controller: messageUploadController,
      message: text,
      files: files,
      replyMessage: reply,
      onClickReplyMessage: scrollTo,
    );

    var now = Jalali.now();
    var date = "${now.year}/" + (now.month > 9 ? "${now.month}" : "0${now.month}") + "/" + (now.day > 9 ? "${now.day}" : "0${now.day}");
    messageWidgets.add(createDate: date, widget: sendingMessageWidget);

    scrollDown();
    if (messageWidgets.widgetLength() == 1) {
      setState(() {});
    } else {
      listViewSetState?.call(() {});
    }

    chatReplyBloc.add(ChatReplyEvent(null));

    sendMessageBloc.add(
      AddToSendQueueEvent(
        chatId: widget.chatId,
        message: text,
        files: files,
        controller: messageUploadController,
        widgetKey: sendingMessageWidget.messageKey.key,
        replyMessage: reply,
      ),
    );
  }

  void onClickUnblock() {
    chatBlockBloc.add(ChatBlockRequestEvent([widget.chatId], false));
  }

  WillPopCallback? onClickBackButton() => () async {
        if (chatSearchBoxMessageStatus.state) {
          chatSearchBoxMessageStatus.add(false);
          return false;
        }

        if (selectMessageBloc.selectedMessages.isNotEmpty) {
          selectMessageBloc.add(SelectMessageClearEvent());
          chatMessageSearchBloc.add(ChatMessageSearchCancelEvent());

          return false;
        }

        if (isOpenEmojiKeyboard) {
          changeEmojiKeyboardStatus.add(false);
          setState(() => isOpenEmojiKeyboard = false);
          return false;
        }

        backToList();

        return false;
      };

  Widget paginationLoadingWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      alignment: Alignment.center,
      child: SpinKitRing(
        color: Colors.black,
        lineWidth: 3,
        size: 20,
      ),
    );
  }

  void backToList() {
    rabbitClient?.close();

    Navigator.pop(context, {
      "chatId": widget.chatId,
      "sentMessage": lastMessage?.message ?? "فایل",
      "newMessageCount": newMessageCount,
      "isBlockByMe": isBlockByMe,
    });
  }
}
