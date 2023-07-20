import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/chat/reply/chat_reply_bloc.dart';
import 'package:siraf3/bloc/chat/search/messages/request/chat_message_search_bloc.dart';
import 'package:siraf3/bloc/chat/select_message/select_message_bloc.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/themes.dart';

import 'chat_massage_action.dart';
import 'chat_message_config.dart';

class MessageWidgetKey {
  late Key key;

  MessageWidgetKey(ChatMessage? chatMessage) {
    if (chatMessage != null) {
      key = Key(chatMessage.id!.toString());
    } else {
      key = Key((DateTime.now().microsecondsSinceEpoch * DateTime.now().millisecond).toString());
    }
  }

  bool equalTo(int messageId) {
    return key == Key(messageId.toString());
  }
}

abstract class MessageWidget extends StatefulWidget {
  MessageWidgetKey messageKey;

  MessageWidget({required this.messageKey}) : super(key: messageKey.key);
}

abstract class AbstractMessageWidget<T extends MessageWidget> extends State<T> with TickerProviderStateMixin {
  double maxWidth() {
    return MediaQuery.of(context).size.width * 0.65;
  }

  double maxHeight() => double.infinity;

  bool isForMe();

  Widget content();

  ChatMessage? message();

  bool onClickDeleteMessage(bool isForAll);

  bool isSelected = false;
  bool canSelectWithClick = false;

  @override
  void initState() {
    super.initState();

    isSelected = BlocProvider.of<SelectMessageBloc>(context).selectedMessages.where((e) => e.key == widget.key).toList().isNotEmpty;

    canSelectWithClick = BlocProvider.of<SelectMessageBloc>(context).selectedMessages.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          left: 0,
          bottom: 0,
          top: 0,
          child: InkWell(
            onTapUp: onTapUpMessage,
            onTap: onClickMessage,
            onLongPress: onLongClickMessage,
            child: BlocConsumer(
              bloc: BlocProvider.of<SelectMessageBloc>(context),
              listener: (context, state) {
                if (state is SelectMessageSelectState && state.widgetKey == widget.key) {
                  isSelected = true;
                }
                if (state is SelectMessageDeselectState && state.widgetKey == widget.key) {
                  isSelected = false;
                }
                if (state is SelectMessageClearState) {
                  isSelected = false;
                }

                if (state is SelectMessageCountSate) {
                  canSelectWithClick = state.count > 0;
                }
              },
              builder: (context, state) {
                return Container(color: !isSelected ? null : Themes.primary.withOpacity(0.08));
              },
            ),
          ),
        ),
        InkWell(
          onTapUp: onTapUpMessage,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              textDirection: getConfig().direction,
              children: [
                Image.asset(
                  isForMe() ? "assets/images/chat-curve.png" : "assets/images/chat-curve-light.png",
                  width: 8,
                  height: 8,
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.fitWidth,
                ),
                Transform.translate(
                  offset: Offset(isForMe() ? 0.3 : -0.3, -.3),
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: getConfig().background,
                      borderRadius: getConfig().borderRadius,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: maxWidth(),
                      minWidth: 100,
                      maxHeight: maxHeight(),
                      minHeight: 15,
                    ),
                    child: ClipRRect(
                      borderRadius: getConfig().borderRadius,
                      child: content(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @protected
  ChatMessageConfig getConfig() {
    return isForMe() ? _forMeConfig() : _forHerConfig();
  }

  Widget replyWidget(ChatMessage? replyMessage, void Function(ChatMessage? chatMessage)? onClickReplyMessage) {
    if (replyMessage == null) return SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onClickReplyMessage?.call(replyMessage),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
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
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        replyMessage.forMe ? "خودم" : "مشاور",
                        style: TextStyle(
                          color: isForMe() ? Colors.white : getConfig().primaryColor,
                          fontSize: 10,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      Text(
                        _replyMessage(replyMessage),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: getConfig().secondTextColor,
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

  String _replyMessage(ChatMessage replyMessage) {
    switch (replyMessage.getTypeFile()) {
      case TypeFile.Image:
        return "عکس";
      case TypeFile.Video:
        return "ویدیو";
      case TypeFile.Voice:
        return "صدا";
      case TypeFile.Doc:
        return "سند";
      default:
        return replyMessage.message ?? "";
    }
  }

  Widget textWidget(String? message, {double? marginVertical}) {
    if (!message.isFill()) return Container();

    Widget widget(String? message, {double? marginVertical, String? searched}) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: marginVertical ?? 3.0),
        child: Wrap(
          children: [
            AutoDirection(
              text: message!,
              child: highlightTextWidget(
                message,
                searched: searched,
                style: TextStyle(color: getConfig().textColor, fontSize: 12, fontFamily: "IranSans"),
                searchedStyle: TextStyle(
                  color: getConfig().textColor,
                  fontSize: 12,
                  fontFamily: "IranSans",
                  backgroundColor: isForMe() ? Color(0xff0f78b6) : Colors.grey.shade300.withOpacity(.9),
                ),
                linkStyle: TextStyle(
                  color: !isForMe() ? getConfig().primaryColor : getConfig().textColor,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                  decorationColor: !isForMe() ? getConfig().primaryColor : getConfig().textColor,
                  decorationThickness: !isForMe() ? 1 : 1.3,
                ),
              ),
            ),
          ],
        ),
      );
    }

    try {
      var bloc = BlocProvider.of<ChatMessageSearchBloc>(context);

      return BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          String? q = state is! ChatMessageSearchSuccess ? null : state.searched;

          return widget(message, marginVertical: marginVertical, searched: q);
        },
      );
    } catch (e) {
      return widget(message, marginVertical: marginVertical);
    }
  }

  Widget footerWidget(bool isSeen, String createTime, {bool sending = false, bool error = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 2, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isForMe() && !sending && !error)
            Icon(
              isSeen ? Icons.done_all_rounded : Icons.check_rounded,
              color: isSeen ? Colors.white : getConfig().secondTextColor,
              size: 13,
            ),
          if (error)
            Icon(
              Icons.error_outlined,
              color: Colors.red,
              size: 13,
            ),
          if (sending)
            Icon(
              Icons.schedule_rounded,
              color: isForMe() ? Colors.white : getConfig().secondTextColor,
              size: 13,
            ),
          if (isForMe() || sending || error) SizedBox(width: 2),
          Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: Text(
              createTime,
              style: TextStyle(
                color: isForMe() ? Colors.white60 : Colors.grey,
                fontSize: 9,
                height: 0.9,
                fontFamily: "sans-serif",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ChatMessageConfig _forMeConfig() {
    return ChatMessageConfig(
      forMe: isForMe(),
      tlRadius: 18,
      trRadius: 18,
      brRadius: 0,
      blRadius: 18,
      fileNameColor: Colors.white,
      background: Themes.primary.withOpacity(1),
      textColor: Colors.white,
      primaryColor: Colors.white,
      secondTextColor: Color(0x8bc0d0e0),
      textDirection: TextDirection.rtl,
    );
  }

  ChatMessageConfig _forHerConfig() {
    return ChatMessageConfig(
      forMe: isForMe(),
      tlRadius: 18,
      trRadius: 18,
      blRadius: 0,
      brRadius: 18,
      fileNameColor: Colors.black,
      background: Color(0xfff0f0f0),
      textColor: Colors.black,
      primaryColor: Themes.primary,
      secondTextColor: Color(0xffb9c0c6),
      textDirection: TextDirection.ltr,
    );
  }

  void onClickMessage() {
    if (isSelected) {
      BlocProvider.of<SelectMessageBloc>(context).add(SelectMessageDeselectEvent(widget.messageKey.key));
    } else if (!isSelected && canSelectWithClick) {
      BlocProvider.of<SelectMessageBloc>(context).add(SelectMessageSelectEvent(widget.messageKey.key, message()?.id));
    } else {}
  }

  void onLongClickMessage() {
    if (!isSelected) {
      BlocProvider.of<SelectMessageBloc>(context).add(SelectMessageSelectEvent(widget.messageKey.key, message()?.id));
    }
  }

  void onTapUpMessage(TapUpDetails details) {
    if ((isSelected || canSelectWithClick)) return;

    showMessageActionMenu(
      context,
      details,
      isForMe: isForMe(),
      deletable: isForMe() || onClickDeleteMessage(false),
      onClickDeleteItem: (bool isForAll) {
        onClickDeleteMessage.call(isForAll);
      },
      onClickAnswerItem: () {
        BlocProvider.of<ChatReplyBloc>(context).add(ChatReplyEvent(message()));
      },
    );
  }

  Text highlightTextWidget(
    String rawString, {
    String? searched,
    required TextStyle linkStyle,
    required TextStyle style,
    TextStyle? searchedStyle,
  }) {
    List<TextSpan> textSpan = [];

    final urlRegExp = RegExp(r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");

    getLink(String linkString) {
      textSpan.add(
        TextSpan(
          text: linkString,
          style: linkStyle,
          recognizer: TapGestureRecognizer()..onTap = () {},
        ),
      );
      return linkString;
    }

    getNormalText(String normalText) {
      textSpan.add(TextSpan(text: normalText, style: style));
      return normalText;
    }

    getSearchedText(String searched) {
      textSpan.add(TextSpan(text: searched, style: searchedStyle));
      return searched;
    }

    rawString.splitMapJoin(
      urlRegExp,
      onMatch: (m) => getLink("${m.group(0)}"),
      onNonMatch: (n) {
        if (searched != null && n.contains(searched)) {
          return getSearchedText(searched);
        } else {
          return getNormalText("${n.substring(0)}");
        }
      },
    );

    return Text.rich(TextSpan(children: textSpan));
  }
}
