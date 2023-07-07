import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:siraf3/bloc/chat/messages/messages_bloc.dart';
import 'package:siraf3/bloc/chat/play/voice_message_play_bloc.dart';
import 'package:siraf3/bloc/chat/recordingVoice/recording_voice_bloc.dart';
import 'package:siraf3/bloc/chat/reply/chat_reply_bloc.dart';
import 'package:siraf3/bloc/chat/seen/seen_message_bloc.dart';
import 'package:siraf3/bloc/chat/select_message/select_message_bloc.dart';
import 'package:siraf3/bloc/chat/sendMessage/send_message_bloc.dart';
import 'package:siraf3/controller/chat_message_upload_controller.dart';
import 'package:siraf3/extensions/file_extension.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/chat_item.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/screens/chat/chat/app_bar_chat_widget.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_icon_button.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';

import 'messageWidgets/chat_message_widget.dart';
import 'message_widget_list.dart';
import 'sendingMessageWidgets/chat_sending_message_widget.dart';

part 'chat_message_editor_widget.dart';

class ChatScreen extends StatefulWidget {
  ChatItem chatItem;

  ChatScreen({required this.chatItem});

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

  TextEditingController messageController = TextEditingController();
  ScrollController _chatController = ScrollController();

  static const double begin_floatingActionButtonOffset = -100;
  static const double end_floatingActionButtonOffset = 10;

  late AnimationController _scrollDownAnimationController;
  late Animation<double> _scrollDownAnimation;

  List<ChatMessage> messages = [];

  MessagesState? nowMessagesState;

  StreamController<bool> showSendButton = StreamController();

  List<File> selectedFilesForUpload = [];
  List<Widget> selectedFilesWidgetForUpload = [];
  bool showReplyMessage = false;
  ChatMessage? replyMessage;

  late AnimationController voiceAnimController;
  late Animation<double> voiceAnim;
  late Animation<double> recordIconAnim;

  String? recorderVoicePath;
  MessageWidgetList messageWidgets = MessageWidgetList();

  late Record record;
  bool isRecording = false;
  void Function(void Function())? listViewSetState = null;
  void Function(void Function())? fileListSetState = null;

  late Timer timer;
  int recordTime = 0;

  StreamController<int> recordTimeStream = StreamController();

  List<MapEntry<Key, int?>> selectedMessages = [];

  @override
  void initState() {
    super.initState();

    record = Record();

    voiceAnimController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    voiceAnim = Tween<double>(begin: 0, end: 5).animate(voiceAnimController..repeat(reverse: true));
    recordIconAnim = Tween<double>(begin: 0.7, end: 1.0).animate(voiceAnimController..repeat(reverse: true));

    _initScrollAnimation();
    _chatController.addListener(_scrollListener);

    _request();

    selectMessageBloc.stream.listen((state) {
      if (state is SelectMessageSelectState) {
        selectedMessages.add(MapEntry(state.widgetKey, state.messageId));
        selectMessageBloc.add(SelectMessageCountEvent(selectedMessages.length));
      }

      if (state is SelectMessageDeselectState) {
        selectedMessages.removeWhere((e) => e.key == state.widgetKey);
        selectMessageBloc.add(SelectMessageCountEvent(selectedMessages.length));
      }
    });

    recordingVoiceBloc.stream.listen((state) async {
      if (state == RecordingVoiceState.Cancel) {
        endTimer();
      }
      if (state == RecordingVoiceState.Recording) {
        startTimer();
      }
      if (state == RecordingVoiceState.Done) {
        endTimer();
        listViewSetState?.call(() {});
      }
    });

    chatMessagesBloc.stream.listen((event) {
      if (event is! MessagesSuccess) return;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => scrollDown());
    });

    sendMessageBloc.stream.listen((state) {
      if (state is SendMessageCanceled) {
        for (var i = 0; i < messageWidgets.length(); i++) {
          if (messageWidgets.get(i).key != state.widgetKey) continue;

          listViewSetState?.call(() => messageWidgets.removeAt(i));

          break;
        }
      }

      if (state is! SendMessageSuccess) return;
      state.playSentSound();
      for (var i = 0; i < messageWidgets.length(); i++) {
        if (messageWidgets.get(i).key != state.widgetKey) continue;

        listViewSetState?.call(() => messageWidgets.replace(
            i,
            ChatMessageWidget(
              key: GlobalObjectKey(state.message.id!),
              message: state.message,
              onClickReplyMessage: scrollTo,
            )));
        break;
      }
    });

    messageController.addListener(_messageControlListener);

    chatReplyBloc.stream.listen((ChatMessage? reply) {
      replyMessage = reply;
      FocusManager.instance.primaryFocus?.requestFocus();
    });
  }

  @override
  void dispose() {
    record.dispose();
    recordingVoiceBloc.close();
    voiceMessagePlayBloc.close();
    selectMessageBloc.close();
    chatMessagesBloc.close();
    _chatController.dispose();
    voiceAnimController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _messageControlListener() {
    showSendButton.add(messageController.value.text.length > 1);
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
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBarChat(chatItem: widget.chatItem),
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
                      Container(
                        padding: EdgeInsets.all(7),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.shade200,
                        ),
                        child: Icon(Icons.home_rounded),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.chatItem.fileTitle ?? "نامشخص",
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      BlocBuilder(bloc: chatMessagesBloc, builder: _blocBuilder),
                      AnimatedBuilder(
                        animation: _scrollDownAnimation,
                        builder: (_, __) {
                          return Positioned(
                            right: 10,
                            bottom: _scrollDownAnimation.value,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: scrollDown,
                              child: Container(
                                width: 45,
                                height: 45,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Colors.grey.shade300, width: 0.7),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 0),
                                      spreadRadius: -1.25,
                                      blurRadius: 1.5,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                                child: icon(Icons.expand_more_rounded),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                chatMessageEditor(),
              ],
            ),
            BlocBuilder(
                bloc: recordingVoiceBloc,
                builder: ((context, state) {
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
                              stream: recordTimeStream.stream,
                              builder: (context, snapshot) {
                                return Text(
                                  timeFormatter(snapshot.data ?? 0),
                                  style: TextStyle(
                                    color: Themes.text,
                                    fontFamily: "IranSansBold",
                                    fontSize: 11,
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
                })),
            BlocBuilder(
              bloc: recordingVoiceBloc,
              builder: ((context, state) {
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
              }),
            ),
            // BlocBuilder(
            //   bloc: recordingVoiceBloc,

            // ),
          ],
        ),
      ),
    );
  }

  void _initScrollAnimation() {
    _scrollDownAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _scrollDownAnimation = Tween<double>(
      end: end_floatingActionButtonOffset,
      begin: begin_floatingActionButtonOffset,
    ).animate(_scrollDownAnimationController);
  }

  void _scrollListener() {
    if (_chatController.position.userScrollDirection == ScrollDirection.forward) {
      if (_scrollDownAnimation.value != end_floatingActionButtonOffset) {
        _scrollDownAnimationController.reset();
        _scrollDownAnimationController.forward();
      }
    }

    if (_chatController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_scrollDownAnimation.value != begin_floatingActionButtonOffset) {
        _scrollDownAnimationController.reset();
        _scrollDownAnimationController.reverse();
      }
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

  Widget _blocBuilder(BuildContext context, MessagesState state) {
    if (state is MessagesInitial) return Container();

    if (state is MessagesLoading) return Align(alignment: Alignment.center, child: Container(alignment: Alignment.center, child: Loading()));

    if (state is MessagesError) {
      return Center(child: TryAgain(onPressed: _request, message: state.message));
    }

    messages = (state as MessagesSuccess).messages;

    if (nowMessagesState != state) {
      nowMessagesState = state;

      for (ChatMessage message in messages) {
        messageWidgets.add(
          createDate: message.createDate!,
          widget: ChatMessageWidget(
            key: GlobalObjectKey(message.id!),
            message: message,
            onClickReplyMessage: scrollTo,
          ),
        );
      }
    }

    if (messages.isFill() && !messages.last.forMe && nowMessagesState != state) {
      seenMessageBloc.add(SeenMessageRequestEvent(widget.chatItem.id!));
    }

    return StatefulBuilder(builder: (context, setState) {
      listViewSetState = setState;

      return ListView(
        shrinkWrap: true,
        reverse: true,
        controller: _chatController,
        children: generateList(),
      );
    });
  }

  _request() {
    chatMessagesBloc.add(MessagesRequestEvent(id: widget.chatItem.id!));
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
        chatId: widget.chatItem.id!,
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
      final index = messageWidgets.indexByKey(GlobalObjectKey(replyMessage.id!)) + 2;

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

  List<Widget> generateList() {
    List<Widget> newList = [];
    newList.add(SizedBox(height: 10));
    newList.addAll(messageWidgets.getList());
    return newList;
  }

  void startTimer() {
    recordTimeStream.add(0);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      recordTimeStream.add(recordTime++);
    });
  }

  void endTimer() {
    recordTime = 0;
    recordTimeStream.add(0);
  }
}
