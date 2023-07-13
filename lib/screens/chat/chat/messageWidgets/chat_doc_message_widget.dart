import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/chat/seen/seen_message_bloc.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/screens/chat/chat/chat_mesage_file_widget.dart';
import 'package:siraf3/screens/chat/chat/chat_message_config.dart';

import 'chat_message_widget.dart';

class ChatDocMessageWidgetState extends ChatMessageWidgetState {
  late ChatMessageConfig messageConfig;
  late bool hasFile;
  late bool hasText;

  @override
  void initState() {
    super.initState();

    messageConfig = getConfig();

    hasFile = widget.fileMessages.isFill();
    hasText = widget.message.message.isFill();

    BlocProvider.of<SeenMessageBloc>(context).stream.listen((state) {
      //todo change to isSeenByUser in consultant app
      widget.message.isSeenByConsultant = state is SeenMessageError;
    });
  }

  @override
  Widget content() {
    return widget.message.message.isFill() ? textAndFileWidget() : fileWidget();
  }

  Widget textAndFileWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        replyWidget(widget.message.replyMessage, widget.onClickReplyMessage),
        for (ChatFileMessage fileMessage in widget.fileMessages)
          ChatMessageFileWidget(
            fileMessage: fileMessage,
            messageConfig: messageConfig,
          ),
        if (hasText && hasFile) textWidget(widget.message.message, marginVertical: 0),
        if (hasFile) footerWidget(widget.message.isSeen, widget.message.createTime!),
        if (!hasFile)
          Wrap(
            verticalDirection: VerticalDirection.up,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              footerWidget(widget.message.isSeen, widget.message.createTime!),
              textWidget(widget.message.message),
            ],
          ),
      ],
    );
  }

  Widget fileWidget() {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            replyWidget(widget.message.replyMessage, widget.onClickReplyMessage),
            for (ChatFileMessage fileMessage in widget.fileMessages)
              ChatMessageFileWidget(
                fileMessage: fileMessage,
                messageConfig: messageConfig,
              ),
          ],
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: footerWidget(widget.message.isSeen, widget.message.createTime!),
        ),
      ],
    );
  }
}
