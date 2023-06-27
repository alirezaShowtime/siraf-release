import 'dart:async';
import 'dart:io';

import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/chat/seen/seen_message_bloc.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/screens/chat/chat/chat_mesage_file_widget.dart';
import 'package:siraf3/screens/chat/chat/chat_message_config.dart';
import 'package:siraf3/themes.dart';

class ChatMessageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatMessageWidgetState();

  ChatMessage message;
  late List<ChatFileMessage> fileMessages;
  late List<File>? files;
  bool isSeen;
  StreamController? onSeenMessageStream;

  ChatMessageWidget({required this.message, this.files, this.isSeen = false}) {
    this.fileMessages = message.fileMessages ?? [];
  }
}

class ChatMessageWidgetState extends State<ChatMessageWidget> {
  late ChatMessageConfig messageConfig;
  late bool hasFile;

  @override
  void initState() {
    super.initState();

    messageConfig = _getConfig();

    hasFile = widget.fileMessages.isFill();

    BlocProvider.of<SeenMessageBloc>(context).stream.listen((state) {
      widget.isSeen = state is SeenMessageError;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: messageConfig.alignment,
      child: Container(
        decoration: BoxDecoration(
          color: messageConfig.background,
          borderRadius: messageConfig.borderRadius,
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.60, minWidth: 100),
        margin: EdgeInsets.only(bottom: 3, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: widget.message.forMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            // if (widget.message.replyMessage != null)
            replyWidget(),
            Padding(
              padding: EdgeInsets.only(top: widget.message.replyMessage != null ? 0 : 5, left: 9, right: 9, bottom: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: widget.message.forMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  for (ChatFileMessage fileMessage in widget.fileMessages)
                    ChatMessageFileWidget(
                      fileMessage: fileMessage,
                      messageConfig: messageConfig,
                      textDirection: messageConfig.fileDirection,
                    ),
                  if (hasFile && widget.message.message.isFill()) SizedBox(height: 10),
                  if (widget.message.message.isFill()) textWidget(),
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.message.forMe)
                          Icon(
                            widget.isSeen ? Icons.done_all_rounded : Icons.check_rounded,
                            color: widget.isSeen ? Colors.white : Colors.white60,
                            size: 12,
                          ),
                        if (widget.message.forMe) SizedBox(width: 4),
                        Text(
                          widget.message.createDate ?? "",
                          style: TextStyle(
                            color: widget.message.forMe ? Colors.white60 : Colors.grey,
                            fontSize: 9,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  ChatMessageConfig _getConfig() {
    return widget.message.forMe ? _forMeConfig() : _forHerConfig();
  }

  ChatMessageConfig _forMeConfig() {
    return ChatMessageConfig(
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

  ChatMessageConfig _forHerConfig() {
    return ChatMessageConfig(
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

  Widget replyWidget() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 2.3,
                  decoration: BoxDecoration(
                    color: widget.message.forMe ? Colors.white60 : messageConfig.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(width: 5),
                Column(
                  children: [
                    Text(
                      "فلیبی بی",
                      style: TextStyle(
                        color: widget.message.forMe ? Colors.white.withOpacity(0.85) : messageConfig.primaryColor,
                        fontSize: 10,
                        fontFamily: "IranSansBold",
                      ),
                    ),
                    Text(
                      "فلیبی بی",
                      style: TextStyle(
                        color: widget.message.forMe ? Colors.white60 : messageConfig.textColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
