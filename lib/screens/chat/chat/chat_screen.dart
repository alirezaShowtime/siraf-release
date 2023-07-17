import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:siraf3/bloc/chat/block/chat_block_bloc.dart';
import 'package:siraf3/bloc/chat/delete/chat_delete_bloc.dart';
import 'package:siraf3/bloc/chat/messages/messages_bloc.dart';
import 'package:siraf3/bloc/chat/play/voice_message_play_bloc.dart';
import 'package:siraf3/bloc/chat/recordingVoice/recording_voice_bloc.dart';
import 'package:siraf3/bloc/chat/reply/chat_reply_bloc.dart';
import 'package:siraf3/bloc/chat/seen/seen_message_bloc.dart';
import 'package:siraf3/bloc/chat/select_message/select_message_bloc.dart';
import 'package:siraf3/bloc/chat/sendMessage/send_message_bloc.dart';
import 'package:siraf3/controller/chat_message_upload_controller.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/screens/chat/chat/app_bar_chat_widget.dart';
import 'package:siraf3/screens/chat/chat/chat_message_editor_widget.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_image.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/try_again.dart';

import 'messageWidgets/chat_message_widget.dart';
import 'message_widget_list.dart';
import 'sendingMessageWidgets/chat_sending_message_widget.dart';

part 'bloc_listeners.dart';

part 'voice_recorder.dart';

class ChatScreen extends StatefulWidget {
  String? consultantName;
  String? consultantImage;
  int? consultantId;
  String? fileTitle;
  String? fileImage;
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
  SendMessageBloc sendMessageBloc = SendMessageBloc();
  SeenMessageBloc seenMessageBloc = SeenMessageBloc();
  ChatReplyBloc chatReplyBloc = ChatReplyBloc();
  RecordingVoiceBloc recordingVoiceBloc = RecordingVoiceBloc();
  VoiceMessagePlayBloc voiceMessagePlayBloc = VoiceMessagePlayBloc();
  SelectMessageBloc selectMessageBloc = SelectMessageBloc();
  ChatBlockBloc chatBlockBloc = ChatBlockBloc();
  ChatDeleteBloc chatDeleteBloc = ChatDeleteBloc();

  ScrollController _chatController = ScrollController();

  static const double begin_floatingActionButtonOffset = -100;
  static const double end_floatingActionButtonOffset = 10;

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

  List<MapEntry<Key, int?>> selectedMessages = [];

  String? lastMessage = "";

  late bool isBlockByMe;
  late bool blockByHer;
  late bool isDeleted;

  Record _audioRecorder = Record();

  ChatMessage? replyMessage;

  @override
  void initState() {
    super.initState();

    isBlockByMe = widget.blockByMe;
    blockByHer = widget.blockByHer;
    isDeleted = widget.isDeleted;

    voiceAnimController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    voiceAnim = Tween<double>(begin: 0, end: 5).animate(voiceAnimController..repeat(reverse: true));
    recordIconAnim = Tween<double>(begin: 0.7, end: 1.0).animate(voiceAnimController..repeat(reverse: true));

    _initScrollAnimation();
    _chatController.addListener(_scrollListener);

    _request();

    chatReplyBlocListener();

    selectMessageBlocListener();

    recordingVoiceBlocListener();

    chatMessagesBlocListener();

    sendMessageBlocListener();

    chatBlockBlocListener();

    chatDeleteBlocListener();
  }

  @override
  void dispose() {
    recordingVoiceBloc.close();
    voiceMessagePlayBloc.close();
    selectMessageBloc.close();
    chatMessagesBloc.close();
    _chatController.dispose();
    voiceAnimController.dispose();
    chatBlockBloc.close();
    chatDeleteBloc.close();
    recordTimeStream.close();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sendMessageBloc),
        BlocProvider(create: (_) => seenMessageBloc),
        BlocProvider(create: (_) => chatReplyBloc),
        BlocProvider(create: (_) => voiceMessagePlayBloc),
        BlocProvider(create: (_) => selectMessageBloc),
        BlocProvider(create: (_) => chatBlockBloc),
        BlocProvider(create: (_) => chatDeleteBloc),
        BlocProvider(create: (_) => recordingVoiceBloc),
      ],
      child: WillPopScope(
        onWillPop: () async {
          if (selectedMessages.isNotEmpty) {
            selectMessageBloc.add(SelectMessageClearEvent());
            return false;
          }

          Navigator.pop(context, {
            "chatId": widget.chatId,
            "sentMessage": lastMessage,
          });

          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBarChat(
            consultantId: widget.consultantId,
            consultantName: widget.consultantName,
            consultantImage: widget.consultantImage,
            chatId: widget.chatId,
            lastMessage: lastMessage,
            isDisable: blockByHer || isBlockByMe,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 55,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300, width: 0.7),
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, -3),
                          spreadRadius: 3,
                          blurRadius: 1,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        MyImage(
                          borderRadius: BorderRadius.circular(5),
                          image: NetworkImage(widget.fileImage ?? ""),
                          errorWidget: defaultFileImage(40),
                          loadingWidget: defaultFileImage(40),
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.fileTitle ?? "نامشخص",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 10, color: Colors.black, fontFamily: "IranSansBold"),
                              ),
                              SizedBox(height: 4),
                              Text(
                                widget.fileTitle ?? "نامشخص",
                                // widget.fileAddress ?? "نامشخص",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 9, color: Colors.black, fontFamily: "IranSansMedium"),
                              ),
                            ],
                          ),
                        ),
                        MyTextButton(
                          onPressed: () {
                            if (widget.fileId != null) {
                              push(context, FileScreen(id: widget.fileId!));
                            }
                          },
                          fontSize: 10,
                          child: Text(
                            "نمایش",
                            style: TextStyle(
                              fontFamily: "IranSansBold",
                              fontSize: 10,
                              color: Themes.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        BlocConsumer(
                          bloc: chatMessagesBloc,
                          builder: _blocBuilder,
                          listener: (context, state) {
                            if (state is! MessagesSuccess) return;
                            messages = state.messages;

                            try {
                              lastMessage = messages.last.message;
                            } catch (e) {}

                            for (ChatMessage message in messages) {
                              messageWidgets.add(
                                createDate: message.createDate!,
                                widget: ChatMessageWidget(
                                  key: Key(message.id.toString()),
                                  message: message,
                                  onClickReplyMessage: scrollTo,
                                ),
                              );
                            }
                            if (messages.isFill() && !messages.last.forMe) {
                              seenMessageBloc.add(SeenMessageRequestEvent(widget.chatId));
                            }
                          },
                        ),
                        AnimatedBuilder(
                          animation: _scrollDownAnimation,
                          builder: (_, __) {
                            return Positioned(
                              right: 10,
                              bottom: _scrollDownAnimation.value,
                              child: FloatingActionButton(
                                onPressed: scrollDown,
                                child: icon(Icons.expand_more_rounded),
                                elevation: 10,
                                mini: true,
                                backgroundColor: Colors.grey.shade50,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isDeleted) notifChatWidget("حذف شده"),
                  if (isBlockByMe) notifChatWidget("رفع مسدودیت", onTap: onClickUnblock),
                  if (blockByHer && !isBlockByMe) notifChatWidget("شما مسدود شداید"),
                  if (!isBlockByMe && !isDeleted && !blockByHer) ChatMessageEditor(onClickSendMessage: sendMessage),
                ],
              ),
              BlocBuilder(
                bloc: recordingVoiceBloc,
                builder: (context, state) {
                  if (state != RecordingVoiceState.Recording) return Container();
                  return Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 0.7)),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(1, -3),
                            spreadRadius: -3,
                            blurRadius: 1,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          AnimatedBuilder(animation: voiceAnim, builder: (_, __) => SizedBox(width: 50 - voiceAnim.value * 3)),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "برای لغو بکشید",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "IranSansBold",
                                    fontSize: 10,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder<int>(
                              initialData: 0,
                              stream: recordTimeStream.stream,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  width: 50,
                                  child: Text(
                                    timeFormatter(snapshot.data!),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Themes.text,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "sans-serif",
                                      fontSize: 11,
                                    ),
                                  ),
                                );
                              }),
                          SizedBox(width: 5),
                          AnimatedBuilder(
                            animation: recordIconAnim,
                            builder: (_, __) {
                              return Icon(Icons.circle, size: 8, color: Colors.red.withOpacity(recordIconAnim.value));
                            },
                          ),
                          SizedBox(width: 15),
                        ],
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder(
                bloc: recordingVoiceBloc,
                builder: (context, state) {
                  if (state != RecordingVoiceState.Recording) return Container();
                  return Positioned(
                    bottom: -20 + (voiceAnim.value * 0),
                    right: -20 + (voiceAnim.value * 0),
                    child: AnimatedBuilder(
                      animation: voiceAnim,
                      builder: (_, __) {
                        return Material(
                          color: Themes.primary,
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 95,
                            width: 95,
                            margin: EdgeInsets.only(top: voiceAnim.value, left: voiceAnim.value),
                            child: Icon(Icons.keyboard_voice_outlined, color: Colors.white),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              // BlocBuilder(
              //   bloc: recordingVoiceBloc,

              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _blocBuilder(BuildContext context, MessagesState state) {
    if (state is MessagesInitial) return Container();

    if (state is MessagesLoading) return Align(alignment: Alignment.center, child: Container(alignment: Alignment.center, child: Loading()));

    if (state is MessagesError) {
      return Center(child: TryAgain(onPressed: _request, message: state.message));
    }

    if (messageWidgets.length() == 0) {
      return Center(
        child: Text(
          "پیامی وجود ندارد",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "IranSansBold",
            fontSize: 10,
          ),
        ),
      );
    }

    return StatefulBuilder(builder: (context, setState) {
      listViewSetState = setState;

      return NotificationListener(
        child: ListView(
          reverse: true,
          controller: _chatController,
          children: generateList(),
        ),
        onNotification: onNotificationListView,
      );
    });
  }

  List<Widget> generateList() {
    List<Widget> newList = [];
    newList.add(SizedBox(height: 10));
    newList.addAll(messageWidgets.getList());
    return newList;
  }

  Widget defaultFileImage(double size) {
    return Container(
      padding: EdgeInsets.all(7),
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Themes.primary.withOpacity(0.1),
      ),
      child: Icon(Icons.home, color: Themes.primary),
    );
  }

  bool onNotificationListView(Notification notification) {
    if (notification is ScrollUpdateNotification) {
      scrollDownButtonTimer?.cancel();
    }

    if (notification is ScrollEndNotification) {
      scrollDownButtonTimer = Timer(Duration(seconds: 3), () {
        _scrollDownAnimationController.reverse();
      });
    }
    return false;
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

  void _initScrollAnimation() {
    _scrollDownAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _scrollDownAnimation = Tween<double>(
      end: end_floatingActionButtonOffset,
      begin: begin_floatingActionButtonOffset,
    ).animate(_scrollDownAnimationController);
  }

  void _scrollListener() {
    if (_chatController.position.pixels < 150) {
      _scrollDownAnimationController.reset();
      _scrollDownAnimationController.reverse();
      return;
    }

    if (_chatController.position.userScrollDirection == ScrollDirection.forward) {
      if (_scrollDownAnimation.value != end_floatingActionButtonOffset) {
        _scrollDownAnimationController.reset();
      }
      _scrollDownAnimationController.forward();
    }

    if (_chatController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_scrollDownAnimation.value != begin_floatingActionButtonOffset) {
        _scrollDownAnimationController.reset();
      }
      _scrollDownAnimationController.reverse();
    }
  }

  void scrollDown({int milliseconds = 2000}) {
    try {
      _chatController.animateTo(
        _chatController.position.minScrollExtent,
        duration: Duration(milliseconds: milliseconds),
        curve: Curves.fastOutSlowIn,
      );
      _scrollDownAnimationController.reverse();
    } catch (e) {}
  }

  void sendMessage(String? text, List<File>? files, ChatMessage? reply) {
    ChatMessageUploadController messageUploadController = ChatMessageUploadController();

    ChatSendingMessageWidget sendingMessageWidget = ChatSendingMessageWidget(
      key: Key("$text ${DateTime.now().microsecondsSinceEpoch}"),
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
    listViewSetState?.call(() {});

    chatReplyBloc.add(ChatReplyEvent(null));

    sendMessageBloc.add(
      AddToSendQueueEvent(
        chatId: widget.chatId,
        message: text,
        files: files,
        controller: messageUploadController,
        widgetKey: sendingMessageWidget.key,
        replyMessage: reply,
      ),
    );
  }

  void scrollTo(ChatMessage? replyMessage) {
    if (replyMessage == null) {
      return notify("پیام پاک شده است");
    }

    try {
      final index = messageWidgets.length() - 1 - messageWidgets.indexByKey(Key(replyMessage.id!.toString())) + 2;

      final contentSize = _chatController.position.viewportDimension + _chatController.position.maxScrollExtent;

      final target = contentSize * index / messageWidgets.length();

      _chatController.position.animateTo(
        target,
        duration: Duration(milliseconds: index < 10 ? 500 : 2000),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      return notify("پیام پاک شده است");
    }
  }

  void onClickUnblock() {
    chatBlockBloc.add(ChatBlockRequestEvent([widget.chatId], false));
  }

  void startTimer() {
    recordTime = 0;
    recordTimeStream.add(recordTime++);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      recordTimeStream.add(recordTime++);
    });
  }

  void endTimer() {
    timer?.cancel();
    timer = null;
    recordTime = 0;
    recordTimeStream.add(0);
  }
}
