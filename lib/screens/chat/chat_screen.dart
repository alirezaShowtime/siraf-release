import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/chat/app_bar_chat_widget.dart';
import 'package:siraf3/screens/chat/chat_message_editor_widget.dart';
import 'package:siraf3/screens/chat/massage_action.dart';
import 'package:siraf3/screens/chat/my_message_widget.dart';
import 'package:siraf3/screens/chat/person_message_widget.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  List<List<Map<String, Object>>> list = [
    [
      {
        "forMe": true,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
      {
        "forMe": true,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
      {
        "forMe": true,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
      {
        "forMe": true,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
    ],
    [
      {
        "forMe": false,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
      {
        "forMe": false,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
    ],
    [
      {
        "forMe": true,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
      {
        "forMe": true,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
    ],
    [
      {
        "forMe": false,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
      {
        "forMe": false,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
      {
        "forMe": false,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
      {
        "forMe": false,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
      {
        "forMe": false,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
      {
        "forMe": false,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
      {
        "forMe": false,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
      {
        "forMe": false,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
      {
        "forMe": false,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
    ],
    [
      {
        "forMe": true,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      }
    ],
    [
      {
        "forMe": false,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
    ],
    [
      {
        "forMe": true,
        "text":
            "lorem kfodpsmkf pods,mf oimfsoi mdsoidmsklf s dmnf kdmsfo  isd  n f k l s d m f  o i k  is n s d fklsd ndo kslf",
        "time": "12:33",
        "isSeen": true,
      },
    ]
  ];

  TextEditingController messageController = TextEditingController();
  ScrollController _chatController = ScrollController();

  static const double begin_floatingActionButtonOffset = -100;
  static const double end_floatingActionButtonOffset = 10;

  late AnimationController _scrollDownAnimationController;
  late Animation<double> _scrollDownAnimation;

  @override
  void initState() {
    super.initState();
    _initScrollAnimation();
    _chatController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();

    _chatController.removeListener(_scrollListener);
    _chatController.dispose();
    _scrollDownAnimationController.removeListener(_animationListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarChat(
        onclickRemoveChat: onclickRemoveChat,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  reverse: true,
                  controller: _chatController,
                  physics: BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    return (list[i].first["forMe"] as bool)
                        ? myMessage(list[i])
                        : personMessage(list[i]);
                  },
                ),
                Positioned(
                  right: 10,
                  bottom: _scrollDownAnimation.value,
                  child: FloatingActionButton(
                    onPressed: scrollDown,
                    child: icon(Icons.expand_more_rounded),
                    elevation: 1,
                    mini: true,
                    backgroundColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
          ChatMessageEditor(
            messageController: messageController,
            replyingMessage: "hellowold",
            onSendMessage: (text) {
              print("onSendMessage called");
            },
          ),
        ],
      ),
    );
  }

  Widget myMessage(List<Map<String, Object>> list) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        children: list.map((item) {
          return MyMessage(
            time: item["time"] as String,
            text: item["text"] as String,
            isFirst: list.first == item,
            isSeen: true,
          );
        }).toList(),
      ),
    );
  }

  Widget personMessage(List<Map<String, Object>> list) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        children: list.map((item) {
          return PersonMessage(
            time: item["time"] as String,
            isFirst: list.first == item,
            //todo: text parameter will be changed
            text: item["text"] as String,
          );
        }).toList(),
      ),
    );
  }

  void _initScrollAnimation() {
    _scrollDownAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _scrollDownAnimation = Tween<double>(
            end: end_floatingActionButtonOffset,
            begin: begin_floatingActionButtonOffset)
        .animate(_scrollDownAnimationController);

    _scrollDownAnimationController.addListener(_animationListener);
  }

  void _scrollListener() {
    if (_chatController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_scrollDownAnimation.value != end_floatingActionButtonOffset) {
        _scrollDownAnimationController.reset();
        _scrollDownAnimationController.forward();
      }
    }

    if (_chatController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_scrollDownAnimation.value != begin_floatingActionButtonOffset) {
        _scrollDownAnimationController.reset();
        _scrollDownAnimationController.reverse();
      }
    }
  }

  void _animationListener() => setState(() {});

  //event listeners
  void scrollDown() {
    //todo: implement event listener
    _chatController.jumpTo(_chatController.position.minScrollExtent);
    _scrollDownAnimationController.reverse();
  }

  void onclickRemoveChat() {
    //todo: implement event listener
    Future.delayed(const Duration(seconds: 0),
        () => confirmDeleteChatDialog(context, onClickDelete: () {}));
  }
}
