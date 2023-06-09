import 'dart:io';

import 'package:siraf3/bloc/ticket/messages/ticket_messages_bloc.dart';
import 'package:siraf3/bloc/ticket/sendMessage/send_message_bloc.dart';
import 'package:siraf3/controller/message_upload_controller.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/ticket.dart';
import 'package:siraf3/models/ticket_details.dart';
import 'package:siraf3/screens/ticket/ticket_chat/app_bar_chat_widget.dart';
import 'package:siraf3/screens/ticket/ticket_chat/chat_message_editor_widget.dart';
import 'package:siraf3/screens/ticket/ticket_chat/message_widget.dart';
import 'package:siraf3/screens/ticket/ticket_chat/sending_message_widget.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketChatScreen extends StatefulWidget {
  Ticket ticket;

  TicketChatScreen({required this.ticket});

  @override
  State<TicketChatScreen> createState() => _TicketChatScreen();
}

class _TicketChatScreen extends State<TicketChatScreen> with SingleTickerProviderStateMixin {
  TicketMessagesBloc ticketMessagesBloc = TicketMessagesBloc();
  SendMessageBloc sendMessageBloc = SendMessageBloc();

  TextEditingController messageController = TextEditingController();
  ScrollController _chatController = ScrollController();

  static const double begin_floatingActionButtonOffset = -100;
  static const double end_floatingActionButtonOffset = 10;

  late AnimationController _scrollDownAnimationController;
  late Animation<double> _scrollDownAnimation;

  List<Message> messages = [];
  late TicketDetails ticketDetails;

  List<Widget> messageWidgets = [];

  TicketMessagesState? nowTicketMessagesState;

  @override
  void initState() {
    super.initState();
    _initScrollAnimation();
    _chatController.addListener(_scrollListener);

    _getTicket();

    ticketMessagesBloc.stream.listen((event) {
      if (event is! TicketMessagesSuccess) return;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        scrollDown(milliseconds: 200);
      });
    });

    sendMessageBloc.stream.listen((state) {
      if (state is! SendMessageSuccess) return;

      for (var i = 0; i < messageWidgets.length; i++) {
        if (messageWidgets[i].key != state.widgetKey) continue;

        setState(() {
          messageWidgets[i] = MessageWidget(message: state.message);
        });

        state.playSentSound();

        break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _chatController.removeListener(_scrollListener);
    _chatController.dispose();
    ticketMessagesBloc.close();
    _scrollDownAnimationController.removeListener(_animationListener);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sendMessageBloc,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xfffbfbfb),
        appBar: AppBarChat(ticket: widget.ticket),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "موضوع",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Wrap(
                      children: [
                        Text(
                          widget.ticket.title ?? "بدون موضوع",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<TicketMessagesBloc, TicketMessagesState>(
              bloc: ticketMessagesBloc,
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

  Widget _blocBuilder(BuildContext context, TicketMessagesState state) {
    if (state is TicketMessagesInitial) return Container();

    if (state is TicketMessagesLoading) return Expanded(child: Container(alignment: Alignment.center, child: Loading()));

    if (state is TicketMessagesError) {
      return Center(
        child: TryAgain(onPressed: _getTicket, message: state.message),
      );
    }

    ticketDetails = (state as TicketMessagesSuccess).ticketDetails;

    if (nowTicketMessagesState != state) {
      nowTicketMessagesState = state;
      messageWidgets = ticketDetails.messages!.map<Widget>((e) => MessageWidget(message: e)).toList();
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

  _getTicket() {
    ticketMessagesBloc.add(TicketMessagesRequestEvent(id: widget.ticket.id!));
  }

  void sendMessage(String text, List<File> files) {
    MessageUploadController messageUploadController = MessageUploadController();
    SendingMessageWidget sendingMessageWidget = SendingMessageWidget(
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
        ticketId: widget.ticket.id!,
        message: text,
        files: files,
        controller: messageUploadController,
        widgetKey: sendingMessageWidget.key!,
      ),
    );
  }
}
