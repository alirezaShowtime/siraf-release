import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:siraf3/bloc/chat/messages/messages_bloc.dart';
import 'package:siraf3/bloc/chat/play/voice_message_play_bloc.dart';
import 'package:siraf3/bloc/chat/recordingVoice/recording_voice_bloc.dart';
import 'package:siraf3/bloc/chat/reply/chat_reply_bloc.dart';
import 'package:siraf3/bloc/chat/seen/seen_message_bloc.dart';
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
import 'sendingMessageWidgets/chat_sending_message_widget.dart';

part 'chat_message_editor_widget.dart';

class ChatScreen extends StatefulWidget {
  ChatItem chatItem;

  ChatScreen({required this.chatItem});

  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> with TickerProviderStateMixin {
  MessagesBloc chatMessagesBloc = MessagesBloc();
  SendMessageBloc sendMessageBloc = SendMessageBloc();
  SeenMessageBloc seenMessageBloc = SeenMessageBloc();
  ChatReplyBloc chatReplyBloc = ChatReplyBloc();
  RecordingVoiceBloc recordingVoiceBloc = RecordingVoiceBloc();
  VoiceMessagePlayBloc voiceMessagePlayBloc = VoiceMessagePlayBloc();

  TextEditingController messageController = TextEditingController();
  ScrollController _chatController = ScrollController();

  static const double begin_floatingActionButtonOffset = -100;
  static const double end_floatingActionButtonOffset = 10;

  late AnimationController _scrollDownAnimationController;
  late Animation<double> _scrollDownAnimation;

  List<ChatMessage> messages = [];
  List<Widget> messageWidgets = [];

  MessagesState? nowMessagesState;

  StreamController<bool> showSendButton = StreamController();

  List<File> selectedFiles = [];
  List<Widget> selectedFilesWidget = [];
  bool showReplyMessage = false;
  ChatMessage? replyMessage;

  late AnimationController voiceAnimController;
  late Animation<double> voiceAnim;
  late Animation<double> recordIconAnim;

  String? recorderVoicePath;

  late Record record;
  bool isRecording = false;
  void Function(void Function())? listViewSetState = null;
  void Function(void Function())? fileListSetState = null;

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

    recordingVoiceBloc.stream.listen((state) async {
      if (state == RecordingVoiceState.Cancel) {}
      if (state == RecordingVoiceState.Recording) {}
      if (state == RecordingVoiceState.Done) {
        listViewSetState?.call(() {});
      }
    });

    chatMessagesBloc.stream.listen((event) {
      if (event is! MessagesSuccess) return;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => scrollDown());
    });

    sendMessageBloc.stream.listen((state) {
      if (state is SendMessageCanceled) {
        for (var i = 0; i < messageWidgets.length; i++) {
          if (messageWidgets[i].key != state.widgetKey) continue;

          listViewSetState?.call(() => messageWidgets.removeAt(i));

          break;
        }
      }

      if (state is! SendMessageSuccess) return;
      state.playSentSound();
      for (var i = 0; i < messageWidgets.length; i++) {
        if (messageWidgets[i].key != state.widgetKey) continue;

        listViewSetState?.call(() {
          messageWidgets[i] = ChatMessageWidget(
            key: GlobalObjectKey(state.message.id!),
            message: state.message,
            onClickReplyMessage: scrollTo,
          );
        });

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
    _chatController.dispose();
    chatMessagesBloc.close();
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
                      BlocBuilder(
                        bloc: chatMessagesBloc,
                        builder: _blocBuilder,
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
                          Text(
                            "00:01:10",
                            style: TextStyle(
                              color: Themes.text,
                              fontFamily: "IranSansBold",
                              fontSize: 11,
                            ),
                          ),
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
    _chatController.animateTo(
      _chatController.position.minScrollExtent,
      duration: Duration(milliseconds: milliseconds),
      curve: Curves.fastOutSlowIn,
    );
    _scrollDownAnimationController.reverse();
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
      messageWidgets = messages.map<Widget>((e) {
        return ChatMessageWidget(
          key: GlobalObjectKey(e.id!),
          message: e,
          onClickReplyMessage: scrollTo,
        );
      }).toList();
    }

    if (!messages.last.forMe && nowMessagesState != state) {
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
      key: UniqueKey(),
      controller: messageUploadController,
      message: text,
      files: files,
      replyMessage: reply,
      onClickReplyMessage: scrollTo,
    );

    messageWidgets.add(sendingMessageWidget);

    scrollDown();
    listViewSetState?.call(() {});

    chatReplyBloc.add(ChatReplyEvent(null));

    sendMessageBloc.add(
      AddToSendQueueEvent(
        chatId: widget.chatItem.id!,
        message: text,
        files: files,
        controller: messageUploadController,
        widgetKey: sendingMessageWidget.key!,
        replyMessage: reply,
      ),
    );
  }

  void scrollTo(ChatMessage? replyMessage) {
    if (replyMessage == null || !messages.contains(replyMessage)) {
      return notify("پیام پاک شده است");
    }

    final contentSize = _chatController.position.viewportDimension + _chatController.position.maxScrollExtent;

    final index = messageWidgets.indexWhere((e) => e.key == GlobalObjectKey(replyMessage.id!)) + 2;

    final target = contentSize * index / messageWidgets.length;

    _chatController.position.animateTo(
      target,
      duration: Duration(milliseconds: index < 10 ? 500 : 2000),
      curve: Curves.easeInOut,
    );
  }

  List<Widget> generateList() {
    List<Widget> newList = [];
    for (int i = messageWidgets.length; i >= 0; i--) {
      newList.add(i == messageWidgets.length || i == 0 ? SizedBox(height: 10) : messageWidgets[i]);
    }
    return newList;
  }
}
