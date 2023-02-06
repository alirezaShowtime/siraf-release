import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/text_field_2.dart';

class ChatMessageEditor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatMessageEditor();

  TextEditingController _messageController;

  //todo: type of the replayingMessage variable is a test type, this variable is possible a model class
  String? replyingMessage;

  //todo: type of the onSendMessage variable is a test type, this variable is possible a model class
  void Function(String text)? onSendMessage;
  void Function()? onRecordVoice;
  void Function()? onAttachEmoji;
  void Function()? onAttachFile;
  void Function()? onCloseReply;

  ChatMessageEditor({
    required TextEditingController messageController,
    this.replyingMessage,
    this.onSendMessage,
    this.onAttachEmoji,
    this.onAttachFile,
    this.onCloseReply,
  }) : _messageController = messageController;
}

class _ChatMessageEditor extends State<ChatMessageEditor> with SingleTickerProviderStateMixin {
  late AnimationController _replyingAnimationController;
  late Animation<double> _replyingAnimation;

  bool showSendButton = false;

  @override
  void initState() {
    super.initState();
    _initReplyingAnimation();

    widget._messageController.addListener(_messageControlListener);
  }

  void _initReplyingAnimation() {
    _replyingAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    _replyingAnimation = CurvedAnimation(parent: _replyingAnimationController, curve: Curves.fastOutSlowIn);

    _replyingAnimationController.addListener(_replyingAnimationControlListener);

    if (widget.replyingMessage != null) {
      _replyingAnimationController.forward();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget._messageController.removeListener(_messageControlListener);
    _replyingAnimationController.removeListener(_replyingAnimationControlListener);
  }

  void _messageControlListener() {
    if (widget._messageController.value.text.length == 0) {
      showSendButton = false;
      setState(() {});
    }

    if (!showSendButton && widget._messageController.value.text.length > 1) {
      showSendButton = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, -3),
            spreadRadius: -3,
            blurRadius: 1,
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        children: [
          if (widget.replyingMessage != null)
            SizeTransition(
              sizeFactor: _replyingAnimation,
              child: replayWidget(),
              axisAlignment: 1.0,
            ),
          Container(
            width: double.infinity,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!showSendButton)
                  Transform.rotate(
                    angle: 180,
                    child: btn(
                      iconData: Icons.attach_file_rounded,
                      onTap: attachFile,
                    ),
                  ),
                if (!showSendButton)
                  btn(
                    iconData: Icons.keyboard_voice_outlined,
                    onTap: recordVoice,
                  ),
                if (showSendButton)
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: btn(
                      iconData: Icons.send_rounded,
                      color: Themes.primary,
                      onTap: sendMessage,
                    ),
                  ),
                Expanded(
                  child: TextField2(
                    controller: widget._messageController,
                    maxLines: 7,
                    minLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "پیام...",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                    ),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                btn(
                  iconData: Icons.sentiment_satisfied,
                  onTap: attachEmoji,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget btn({
    required IconData iconData,
    required Function() onTap,
    Color? color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: icon(iconData, color: color ?? Colors.grey.shade400),
      ),
    );
  }

  //event listeners
  void attachEmoji() {
    //todo: implement event listener
    widget.onAttachEmoji?.call();
  }

  void attachFile() {
    //todo: implement event listener
    widget.onAttachFile?.call();
  }

  void recordVoice() {
    //todo: implement event listener
    widget.onRecordVoice?.call();
  }

  void sendMessage() {
    //todo: implement event listener

    FocusManager.instance.primaryFocus?.unfocus();

    widget.onSendMessage?.call(widget._messageController.value.text);
  }

  void closeReplaying() {
    _replyingAnimationController.reverse();

    widget.onCloseReply?.call();
  }

  Widget replayWidget() {
    return Container(
      height: 45,
      padding: EdgeInsets.only(left: 10, right: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 0.7),
        ),
      ),
      child: Row(
        children: [
          btn(iconData: Icons.close_rounded, onTap: closeReplaying),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Alireza",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Themes.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    children: [
                      Text(
                        "  یسنحبجینس خبنیسحخ بنیحخسب",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          icon(Icons.reply_rounded, color: Themes.primary),
        ],
      ),
    );
  }

  void _replyingAnimationControlListener() {
    setState(() {});
  }
}
