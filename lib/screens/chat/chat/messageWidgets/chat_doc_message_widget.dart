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

  @override
  void initState() {
    super.initState();

    messageConfig = getConfig();

    hasFile = widget.fileMessages.isFill();

    BlocProvider.of<SeenMessageBloc>(context).stream.listen((state) {
      widget.isSeen = state is SeenMessageError;
    });
  }

  @override
  Widget content() {
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
        if (hasFile && widget.message.message.isFill()) SizedBox(height: 10),
        Wrap(
          verticalDirection: VerticalDirection.up,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            footerWidget(widget.isSeen, widget.message.createTime!),
            if (widget.message.message.isFill()) textWidget(widget.message.message),
          ],
        ),
      ],
    );
  }
}
