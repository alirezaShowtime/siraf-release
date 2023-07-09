import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/screens/chat/chat/abstract_message_widget.dart';
import 'package:siraf3/screens/chat/chat/messageWidgets/chat_doc_message_widget.dart';
import 'package:siraf3/screens/chat/chat/messageWidgets/chat_image_message_widget.dart';
import 'package:siraf3/screens/chat/chat/messageWidgets/chat_video_message_widget.dart';
import 'package:siraf3/screens/chat/chat/messageWidgets/chat_voice_message_widget.dart';

class ChatMessageWidget extends MessageWidget {
  ChatMessage message;
  late List<ChatFileMessage> fileMessages;
  late List<File>? files;
  StreamController? onSeenMessageStream;
  void Function(ChatMessage? replyMessage)? onClickReplyMessage;

  ChatMessageWidget({
    required super.key,
    required this.message,
    this.files,
    this.onClickReplyMessage,
  }) {
    this.fileMessages = message.fileMessages ?? [];
  }

  @override
  State<StatefulWidget> createState() {
    if (message.getTypeFile() == TypeFile.Voice) {
      return ChatVoiceMessageWidgetState();
    } else if (message.getTypeFile() == TypeFile.Video) {
      return ChatVideoMessageWidgetState();
    } else if (message.getTypeFile() == TypeFile.Image) {
      return ChatImageMessageWidgetState();
    } else {
      return ChatDocMessageWidgetState();
    }
  }
}

abstract class ChatMessageWidgetState extends AbstractMessageWidget<ChatMessageWidget> {
  @override
  bool isForMe() => widget.message.forMe;

  @override
  ChatMessage? message() => widget.message;
}
