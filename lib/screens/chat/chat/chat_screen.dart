import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/chat/messages/messages_bloc.dart';
import 'package:siraf3/bloc/chat/seen/seen_message_bloc.dart';
import 'package:siraf3/bloc/chat/sendMessage/send_message_bloc.dart';
import 'package:siraf3/controller/message_upload_controller.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/chat_item.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/screens/chat/chat/app_bar_chat_widget.dart';
import 'package:siraf3/screens/chat/chat/chat_message_editor_widget.dart';
import 'package:siraf3/screens/chat/chat/chat_message_widget.dart';
import 'package:siraf3/screens/chat/chat/chat_sending_message_widget.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/try_again.dart';

class ChatScreen extends StatefulWidget {
  ChatItem chatItem;

  ChatScreen({required this.chatItem});

  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> with SingleTickerProviderStateMixin {
  MessagesBloc chatMessagesBloc = MessagesBloc();
  SendMessageBloc sendMessageBloc = SendMessageBloc();
  SeenMessageBloc seenMessageBloc = SeenMessageBloc();

  TextEditingController messageController = TextEditingController();
  ScrollController _chatController = ScrollController();

  static const double begin_floatingActionButtonOffset = -100;
  static const double end_floatingActionButtonOffset = 10;

  late AnimationController _scrollDownAnimationController;
  late Animation<double> _scrollDownAnimation;

  List<ChatMessage> messages = [];
  List<Widget> messageWidgets = [];

  MessagesState? nowMessagesState;

  @override
  void initState() {
    super.initState();
    _initScrollAnimation();
    _chatController.addListener(_scrollListener);

    _request();

    chatMessagesBloc.stream.listen((event) {
      if (event is! MessagesSuccess) return;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        scrollDown(milliseconds: 200);
      });
    });

    sendMessageBloc.stream.listen((state) {
      if (state is SendMessageCanceled) {
        for (var i = 0; i < messageWidgets.length; i++) {
          if (messageWidgets[i].key != state.widgetKey) continue;

          setState(() => messageWidgets.removeAt(i));

          break;
        }
      }

      if (state is! SendMessageSuccess) return;
      state.playSentSound();
      for (var i = 0; i < messageWidgets.length; i++) {
        if (messageWidgets[i].key != state.widgetKey) continue;

        setState(() {
          messageWidgets[i] = ChatMessageWidget(message: state.message);
        });

        break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _chatController.removeListener(_scrollListener);
    _chatController.dispose();
    chatMessagesBloc.close();
    _scrollDownAnimationController.removeListener(_animationListener);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sendMessageBloc),
        BlocProvider(create: (_) => seenMessageBloc),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xfffbfbfb),
        appBar: AppBarChat(chatItem: widget.chatItem),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    spreadRadius: -6,
                    blurRadius: 3,
                    color: Color.fromRGBO(201, 201, 201, 1.0),
                  ),
                ],
              ),
              child: Wrap(
                children: [
                  Text(
                    widget.chatItem.fileTitle ?? "نامشخص",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
            ),
            BlocBuilder<MessagesBloc, MessagesState>(
              bloc: chatMessagesBloc,
              builder: _blocBuilder,
            ),
            ChatMessageEditor(
              messageController: messageController,
              onClickSendMessage: sendMessage,
            ),
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

    _scrollDownAnimationController.addListener(_animationListener);
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

  void _animationListener() => setState(() {});

  //event listeners
  void scrollDown({int milliseconds = 2000}) {
    _chatController.animateTo(
      _chatController.position.maxScrollExtent,
      duration: Duration(milliseconds: milliseconds),
      curve: Curves.fastOutSlowIn,
    );
    _scrollDownAnimationController.reverse();
  }

  Widget _blocBuilder(BuildContext context, MessagesState state) {
    if (state is MessagesInitial) return Container();

    if (state is MessagesLoading) return Expanded(child: Container(alignment: Alignment.center, child: Loading()));

    if (state is MessagesError) {
      return Center(
        child: TryAgain(onPressed: _request, message: state.message),
      );
    }

    messages = (state as MessagesSuccess).messages;

    if (nowMessagesState != state) {
      nowMessagesState = state;
      messageWidgets = messages.map<Widget>((e) => ChatMessageWidget(message: e)).toList();
    }

    if (!messages.last.forMe && nowMessagesState != state) {
      seenMessageBloc.add(SeenMessageRequestEvent(widget.chatItem.id!));
    }

    return Expanded(
      child: Stack(
        children: [
          ListView.builder(
            controller: _chatController,
            itemCount: messageWidgets.length + 2,
            itemBuilder: (_, i) {
              if (i == 0) {
                return SizedBox(height: 60);
              }

              if (i == messageWidgets.length + 1) {
                return SizedBox(height: 20);
              }
              return messageWidgets[i - 1];
            },
          ),
          Positioned(
            right: 10,
            bottom: _scrollDownAnimation.value,
            child: FloatingActionButton(
              onPressed: scrollDown,
              child: icon(Icons.expand_more_rounded),
              elevation: 10,
              mini: true,
              backgroundColor: Colors.grey.shade50,
            ),
          )
        ],
      ),
    );
  }

  _request() {
    chatMessagesBloc.add(MessagesRequestEvent(id: widget.chatItem.id!));
  }

  void sendMessage(String? text, List<File>? files) {
    MessageUploadController messageUploadController = MessageUploadController();
    ChatSendingMessageWidget sendingMessageWidget = ChatSendingMessageWidget(
      key: Key(DateTime.now().microsecond.toString()),
      controller: messageUploadController,
      message: text,
      files: files,
    );

    messageWidgets.add(sendingMessageWidget);

    scrollDown(milliseconds: 200);
    setState(() {});

    sendMessageBloc.add(
      AddToSendQueueEvent(
        chatId: widget.chatItem.id!,
        message: text,
        files: files,
        controller: messageUploadController,
        widgetKey: sendingMessageWidget.key!,
      ),
    );
  }
}
