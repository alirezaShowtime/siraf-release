import 'package:flutter/material.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_back_button.dart';

import 'package:siraf3/screens/chat/chat_message_editor_widget.dart';
import 'package:siraf3/screens/chat/person_message_widget.dart';
import 'package:siraf3/screens/chat/my_message_widget.dart';
import 'package:siraf3/screens/chat/app_bar_chat_widget.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
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

  @override
  void initState() {
    super.initState();

    // _chatController.jumpTo(_chatController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarChat(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Stack(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: _chatController,
                      physics: BouncingScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, i) {
                        return (list[i].first["forMe"] as bool)
                            ? myMessage(list[i])
                            : personMessage(list[i]);
                      },
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: FloatingActionButton(
                      onPressed: scrollDown,
                      child: icon(Icons.expand_more_rounded, size: 20),
                      elevation: 1,
                      mini: true,
                      backgroundColor: Colors.white,
                    ),
                  )
                ],
              )),
          ChatMessageEditor(
            messageController: messageController,
            replyingMessage: "fdsfsdf",
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
            time: "12:23",
            text: "fdskfodsfjdsf",
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
            time: "23:4343",
            isFirst: list.first == item,
            text:
            "ایم بنیحخبن یحخبن تیس بیحخینحخنسصde reorke porkewo ثقخقنثصحخقنثصخنقثص",
          );
        }).toList(),
      ),
    );
  }

  //event listeners
  void scrollDown() {
    //todo: implement event listener
    print("Scroll: ${_chatController.position.pixels}");
    _chatController.jumpTo(_chatController.position.maxScrollExtent);
    print("Scroll: ${_chatController.position.pixels}");
  }
}
