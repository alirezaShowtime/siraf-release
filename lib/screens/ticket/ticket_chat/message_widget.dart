import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/enums/message_owner.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/helpers.dart';
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

  MessageWidget({required this.message}) {
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
                if (hasFile && widget.message.message.isNotNullOrEmpty()) SizedBox(height: 10),
                if (widget.message.message.isNotNullOrEmpty()) textWidget(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 10),
            child: Text(
              widget.message.createDate ?? "",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 9, height: 1),
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
            child: Text(
              widget.message.message!,
              style: TextStyle(color: messageConfig.textColor, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  MessageConfig _getConfig() {
    return widget.messageOwner == MessageOwner.ForME ? _forMeConfig() : _forHerConfig();
  }

  MessageConfig _forMeConfig() {
    return MessageConfig(
      tlRadius: 18,
      trRadius: 18,
      blRadius: 18,
      brRadius: 0,
      fileNameColor: Colors.white,
      background: Themes.primary,
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
      primaryColor: Themes.primary,
      secondTextColor: Colors.grey.shade400,
      textDirection: TextDirection.rtl,
    );
  }
}