import 'dart:io';

import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:linkwell/linkwell.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/enums/message_owner.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/models/ticket_details.dart';
import 'package:siraf3/screens/ticket/ticket_chat/mesage_file_widget.dart';
import 'package:siraf3/screens/ticket/ticket_chat/message_config.dart';
import 'package:siraf3/themes.dart';

class MessageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MessageWidgetState();

  Message message;
  late MessageOwner messageOwner;
  late List<FileMessage> fileMessages;
  late List<File>? files;

  MessageWidget({required this.message, this.files}) {
    this.fileMessages = message.fileMessage ?? [];
    this.messageOwner = message.owner;
  }
}

class MessageWidgetState extends State<MessageWidget> {
  late MessageConfig messageConfig;
  late bool hasFile;

  @override
  void initState() {
    super.initState();

    messageConfig = _getConfig();

    hasFile = widget.fileMessages.isFill();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: messageConfig.alignment,
      child: Column(
        textDirection: messageConfig.fileDirection,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: messageConfig.background,
              borderRadius: messageConfig.borderRadius,
            ),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.60, minWidth: 100),
            margin: EdgeInsets.only(bottom: 3, left: 10, right: 10),
            padding: EdgeInsets.only(top: 5, left: 9, right: 9, bottom: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (FileMessage fileMessage in widget.fileMessages)
                  MessageFileWidget(
                    fileMessage: fileMessage,
                    messageConfig: messageConfig,
                    textDirection: messageConfig.fileDirection,
                  ),
                if (hasFile && widget.message.message.isFill()) SizedBox(height: 10),
                if (widget.message.message.isFill()) textWidget(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 10),
            child: Text(
              "${widget.message.createDate} ${widget.message.createTime}",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 9,
                height: 1,
                fontFamily: "sans-serif",
              ),
              textDirection: TextDirection.ltr,
            ),
          ),
        ],
      ),
    );
  }

  Widget textWidget() {
    return Wrap(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
          child: AutoDirection(
              text: widget.message.message!,
              child: LinkWell(
                widget.message.message!,
                style: TextStyle(color: messageConfig.textColor, fontSize: 12, fontFamily: "IranSans"),
                linkStyle: TextStyle(
                  color: !isForMe() ? messageConfig.primaryColor : messageConfig.textColor,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                  decorationColor: !isForMe() ? messageConfig.primaryColor : messageConfig.textColor,
                  decorationThickness: !isForMe() ? 1 : 1.3,
                ),
              )),
        ),
      ],
    );
  }

  MessageConfig _getConfig() {
    return widget.messageOwner == MessageOwner.ForMe ? _forMeConfig() : _forHerConfig();
  }

  MessageConfig _forMeConfig() {
    return MessageConfig(
      tlRadius: 18,
      trRadius: 18,
      blRadius: 18,
      brRadius: 0,
      fileNameColor: Colors.white,
      background: App.theme.primaryColor,
      textColor: Colors.white,
      primaryColor: Colors.white,
      secondTextColor: Color(0x8bc0d0e0),
      textDirection: TextDirection.ltr,
    );
  }

  MessageConfig _forHerConfig() {
    return MessageConfig(
      tlRadius: 18,
      trRadius: 18,
      blRadius: 0,
      brRadius: 18,
      fileNameColor: Colors.black,
      background: Colors.grey.shade200,
      textColor: Colors.black,
      primaryColor: App.theme.primaryColor,
      secondTextColor: Colors.grey.shade400,
      textDirection: TextDirection.rtl,
    );
  }

  bool isForMe() => widget.message.owner == MessageOwner.ForMe;
}
