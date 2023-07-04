import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:siraf3/bloc/chat/reply/chat_reply_bloc.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/themes.dart';

import 'chat_message_config.dart';

abstract class MessageWidget extends StatefulWidget {
  // StreamController<bool> isLast = StreamController();
  // StreamController<bool> isFirst = StreamController();

  MessageWidget({super.key}) {
    // isLast.add(false);
    // isFirst.add(false);
  }
}

abstract class AbstractMessageWidget<T extends MessageWidget> extends State<T> with TickerProviderStateMixin {
  bool isForMe();

  Widget content();

  ChatMessage? messageForReply();

  bool isFirst = false;
  bool isLast = false;

  @override
  void initState() {
    super.initState();
/*
    widget.isFirst.stream.listen((v) {
      isFirst = v;

      try {
        setState(() {});
      } catch (e) {}
    });
    widget.isLast.stream.listen((v) {
      isLast = v;

      try {
        setState(() {});
      } catch (e) {}
    });
 */
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: getConfig().alignment,
      margin: EdgeInsets.only(bottom: /*isLast ? 10 :*/ 2, left: 5, right: 5, top: /*isLast ? 10 :*/ 2),
      child: Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          motion: ScrollMotion(),
          extentRatio: 0.25,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Builder(builder: (context) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      Slidable.of(context)?.close();
                      BlocProvider.of<ChatReplyBloc>(context).add(ChatReplyEvent(messageForReply()));
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.shade100,
                      ),
                      child: icon(Icons.reply_rounded, size: 18, color: Themes.text),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: getConfig().borderRadius,
            color: getConfig().background,
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.65,
            minWidth: 100,
            // maxHeight: 600,
          ),
          child: ClipRRect(
            borderRadius: getConfig().borderRadius,
            child: content(),
          ),
        ),
      ),
    );
  }

  @protected
  ChatMessageConfig getConfig() {
    return isForMe() ? _forMeConfig() : _forHerConfig();
  }

  Widget replyWidget(ChatMessage? replyMessage, void Function(ChatMessage? chatMessage)? onClickReplyMessage) {
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
                    color: isForMe() ? Colors.white : getConfig().primaryColor,
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
                          color: isForMe() ? Colors.white.withOpacity(0.85) : getConfig().primaryColor,
                          fontSize: 10,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      Text(
                        replyMessage.message ?? "فایل",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: isForMe() ? Colors.white60 : getConfig().textColor,
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
      padding: const EdgeInsets.only(left: 7, right: 7, top: 7),
      child: Wrap(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.60),
            child: AutoDirection(
              text: message!,
              child: Text(
                message,
                style: TextStyle(color: getConfig().textColor, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget footerWidget(bool isSeen, String createTime) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0, right: 7),
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
            style: TextStyle(
              color: isForMe() ? Colors.white60 : Colors.grey,
              fontSize: 9,
              height: 0.9,
              fontFamily: "sans-serif",
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  ChatMessageConfig _forMeConfig() {
    return ChatMessageConfig(
      // tlRadius: 18,
      // trRadius: isFirst ? 18 : 5,
      // blRadius: 18,
      // brRadius: isLast ? 0 : 5,
      tlRadius: 18,
      trRadius: 18,
      brRadius: 18,
      blRadius: 18,
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
      // tlRadius: isFirst ? 18 : 5,
      // trRadius: 18,
      // blRadius: isLast ? 0 : 5,
      // brRadius: 18,
      tlRadius: 18,
      trRadius: 18,
      blRadius: 18,
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
