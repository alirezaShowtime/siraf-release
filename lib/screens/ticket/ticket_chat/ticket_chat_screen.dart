import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:siraf3/bloc/ticket/close/close_ticket_bloc.dart';
import 'package:siraf3/bloc/ticket/messages/ticket_messages_bloc.dart';
import 'package:siraf3/bloc/ticket/sendMessage/send_message_bloc.dart';
import 'package:siraf3/controller/message_upload_controller.dart';
import 'package:siraf3/dark_themes.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/enums/message_owner.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/ticket.dart';
import 'package:siraf3/models/ticket_details.dart';
import 'package:siraf3/screens/ticket/ticket_chat/app_bar_chat_widget.dart';
import 'package:siraf3/screens/ticket/ticket_chat/chat_message_editor_widget.dart';
import 'package:siraf3/screens/ticket/ticket_chat/message_widget.dart';
import 'package:siraf3/screens/ticket/ticket_chat/sending_message_widget.dart';
import 'package:siraf3/widgets/confirm_dialog.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/try_again.dart';

part 'chat_scroll_controller.dart';

class TicketChatScreen extends StatefulWidget {
  Ticket ticket;

  TicketChatScreen({required this.ticket});

  @override
  State<TicketChatScreen> createState() => _TicketChatScreen();
}

class _TicketChatScreen extends State<TicketChatScreen> with SingleTickerProviderStateMixin {
  TicketMessagesBloc ticketMessagesBloc = TicketMessagesBloc();
  SendMessageBloc sendMessageBloc = SendMessageBloc();
  CloseTicketBloc closeTicketBloc = CloseTicketBloc();

  TextEditingController messageController = TextEditingController();

  List<Message> messages = [];
  late TicketDetails ticketDetails;

  List<Widget> messageWidgets = [];
  List<MessageOwner> messageOwners = [];

  TicketMessagesState? nowTicketMessagesState;
  bool ticketIsClosed = false;
  Timer? scrollDownButtonTimer;

  final ItemScrollController chatItemScrollController = ItemScrollController();

  final double begin_floatingActionButtonOffset = -100;
  final double end_floatingActionButtonOffset = 10;
  late AnimationController _scrollDownAnimationController;
  late Animation<double> _scrollDownAnimation;
  String lastMessage = "";

  @override
  void initState() {
    super.initState();

    ticketIsClosed = !widget.ticket.status;

    initScrollAnimation();

    _getTicket();

    ticketMessagesBloc.stream.listen((event) {
      if (event is! TicketMessagesSuccess) return;

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
          messageWidgets[i] = MessageWidget(message: state.message);
          lastMessage = state.message.message ?? "";
        });

        break;
      }
    });

    closeTicketBloc.stream.listen((state) {
      if (state is CloseTicketLoading) {
        dismissDialog(errorDialogContext);
        loadingDialog(context: context);
        return;
      }

      if (state is CloseTicketError) {
        dismissDialog(loadingDialogContext);
        errorDialog(context: context, message: state.message);
        return;
      }

      if (state is CloseTicketSuccess) {
        dismissDialog(loadingDialogContext);
        notify(" تیکت بسته شد.");
        setState(() {
          ticketIsClosed = true;
        });
      }
    });
  }

  @override
  void dispose() {
    ticketMessagesBloc.close();
    _scrollDownAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        sendMessageBloc.close();

        Navigator.pop(context, {
          "lastMessage": lastMessage,
          "isClosed": ticketIsClosed,
        });

        return false;
      },
      child: MultiBlocProvider(
        providers: [BlocProvider<SendMessageBloc>(create: (_) => sendMessageBloc)],
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBarChat(
            onclickCloseChat: onclickCloseChat,
            ticket: widget.ticket,
            ticketIsClosed: ticketIsClosed,
            lastMessage: lastMessage,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: App.theme.dialogBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 5),
                      spreadRadius: -6,
                      blurRadius: 3,
                      color: App.theme.shadowColor,
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
                        color: App.theme.tooltipTheme.textStyle?.color,
                        fontSize: 9,
                        fontFamily: "IranSansBold",
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
                              fontFamily: "IranSansMedium",
                              fontSize: 12,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              BlocConsumer(
                bloc: ticketMessagesBloc,
                builder: _blocBuilder,
                listener: (context, state) {
                  if (state is! TicketMessagesSuccess) return;

                  ticketDetails = state.ticketDetails;

                  messageWidgets = ticketDetails.messages!.map<Widget>((e) => MessageWidget(message: e)).toList();

                  lastMessage = ticketDetails.messages!.last.message ?? "";
                },
              ),
              if (ticketIsClosed)
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: App.isDark ? DarkThemes.background2 : Colors.grey.shade100,
                    border: Border(top: BorderSide(color: App.theme.shadowColor)),
                  ),
                  child: Text(
                    "تیکت بسته شده است",
                    style: TextStyle(color: App.theme.primaryColor, fontSize: 12, fontFamily: "IranSansBold"),
                  ),
                ),
              if (!ticketIsClosed)
                ChatMessageEditor(
                  messageController: messageController,
                  onClickSendMessage: sendMessage,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void onclickCloseChat() {
    Future.delayed(const Duration(seconds: 0), () {
      animationDialog(
          context: context,
          builder: (dialogContext) {
            return ConfirmDialog(
              title: "بستن تیکت",
              content: "آیا واقعا قصد بستن تیکت را دارید؟",
              dialogContext: dialogContext,
              onApply: () {
                closeTicketBloc.add(CloseTicketRequestEvent([widget.ticket.id!]));
                dismissDialog(dialogContext);
              },
            );
          });
    });
  }

  Widget _blocBuilder(BuildContext context, TicketMessagesState state) {
    if (state is TicketMessagesInitial) return Container();

    if (state is TicketMessagesLoading) return Expanded(child: Container(alignment: Alignment.center, child: Loading()));

    if (state is TicketMessagesError) {
      return Expanded(
        child: Container(
          child: Center(
            child: TryAgain(onPressed: _getTicket, message: state.message),
          ),
        ),
      );
    }

    return Expanded(
      child: Stack(
        children: [
          NotificationListener(
            onNotification: onNotificationListView,
            child: ScrollablePositionedList.builder(
              reverse: true,
              itemCount: messageWidgets.length + 2,
              addAutomaticKeepAlives: true,
              itemScrollController: chatItemScrollController,
              itemBuilder: (_, i) {
                if (i == 0) {
                  messageOwners.clear();
                  return SizedBox(height: 5);
                }

                if (i == messageWidgets.length + 1) {
                  Future.delayed(Duration(milliseconds: 100), () {
                    for (int v = 0; v < messageWidgets.length; v++) {
                      if (messageWidgets[v] is MessageWidget) {
                        (messageWidgets[v] as MessageWidget).messageOwner = messageOwners[v];

                        print((messageWidgets[v] as MessageWidget).message.message.toString() + " : " + (messageWidgets[v] as MessageWidget).messageOwner.toString());
                      }
                    }
                  });

                  return SizedBox(height: 60);
                }

                var messageWidget = messageWidgets[i - 1];

                var owner = MessageOwner.ForMe;

                if (messageWidget is MessageWidget) {
                  owner = messageWidget.messageOwner;
                }

                messageOwners.add(owner);

                return Row(
                  mainAxisAlignment: owner == MessageOwner.ForMe ? MainAxisAlignment.start : MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [messageWidget],
                );
              },
            ),
          ),
          ScrollDownButtonWidget()
        ],
      ),
    );
  }

  _getTicket() {
    ticketMessagesBloc.add(TicketMessagesRequestEvent(id: widget.ticket.id!));
  }

  void sendMessage(String? text, List<File>? files) {
    MessageUploadController messageUploadController = MessageUploadController();

    SendingMessageWidget sendingMessageWidget = SendingMessageWidget(
      key: Key("${DateTime.now().millisecondsSinceEpoch}-${DateTime.now().microsecond}"),
      controller: messageUploadController,
      message: text,
      files: files,
    );

    setState(() {
      messageWidgets.insert(0, sendingMessageWidget);
    });

    scrollDown();
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
