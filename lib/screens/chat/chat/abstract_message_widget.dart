import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/chat/reply/chat_reply_bloc.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/themes.dart';

import 'chat_message_config.dart';

abstract class AbstractMessageWidget<T extends StatefulWidget> extends State<T> {
  bool isForMe();

  Widget content();

  ChatMessage? messageForReply();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: _getConfig().alignment,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: isForMe() ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 3, left: 10, right: 10),
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: _getConfig().borderRadius,
              color: _getConfig().background,
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
              minWidth: 100,
              // maxHeight: 600,
            ),
            child: ClipRRect(
              borderRadius: _getConfig().borderRadius,
              child: content(),
            ),
          ),
          if (messageForReply() != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {
                  BlocProvider.of<ChatReplyBloc>(context).add(ChatReplyEvent(messageForReply()));
                },
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: icon(Icons.reply_rounded, size: 18, color: Themes.text),
                ),
              ),
            ),
        ],
      ),
    );
  }

  ChatMessageConfig _getConfig() {
    return isForMe() ? _forMeConfig() : _forHerConfig();
  }

  Widget replyWidget(ChatMessage? replyMessage, void Function(ChatMessage chatMessage)? onClickReplyMessage) {
    if (replyMessage == null) return Container();
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onClickReplyMessage?.call(replyMessage),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 2.3,
                  decoration: BoxDecoration(
                    color: isForMe() ? Colors.white : _getConfig().primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        replyMessage.forMe ? "خودم" : "مشاور",
                        style: TextStyle(
                          color: isForMe() ? Colors.white.withOpacity(0.85) : _getConfig().primaryColor,
                          fontSize: 10,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      Text(
                        replyMessage.message ?? "فایل",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: isForMe() ? Colors.white60 : _getConfig().textColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textWidget(String? message) {
    if (!message.isFill()) return Container();
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Wrap(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.60),
            child: AutoDirection(
              text: message!,
              child: Text(
                message,
                style: TextStyle(color: _getConfig().textColor, fontSize: 12, height: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget footerWidget(bool isSeen, String createTime) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isForMe())
            Icon(
              isSeen ? Icons.done_all_rounded : Icons.check_rounded,
              color: isSeen ? Colors.white : Colors.white60,
              size: 12,
            ),
          if (isForMe()) SizedBox(width: 2),
          Text(
            createTime,
            style: TextStyle(color: isForMe() ? Colors.white60 : Colors.grey, fontSize: 9, height: 1, fontFamily: "sans-serif"),
          ),
        ],
      ),
    );
  }

  ChatMessageConfig _forMeConfig() {
    return ChatMessageConfig(
      tlRadius: 18,
      trRadius: 18,
      blRadius: 18,
      brRadius: 0,
      fileNameColor: Colors.white,
      background: Themes.primary.withOpacity(0.9),
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
      background: Color(0xfff0f0f0),
      textColor: Colors.black,
      primaryColor: Themes.primary,
      secondTextColor: Color(0xffb9c0c6),
      textDirection: TextDirection.rtl,
    );
  }
}
