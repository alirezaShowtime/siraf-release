import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:siraf3/bloc/chat/delete_message/chat_delete_message_bloc.dart';
import 'package:siraf3/controller/chat_message_upload_controller.dart';
import 'package:siraf3/extensions/file_extension.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/screens/chat/chat/abstract_message_widget.dart';
import 'package:siraf3/screens/chat/chat/sendingMessageWidgets/chat_sending_doc_message_widget.dart';
import 'package:siraf3/screens/chat/chat/sendingMessageWidgets/chat_sending_image_message_widget.dart';

import 'chat_sending_video_message_widget.dart';
import 'chat_sending_voice_message_widget.dart';

class ChatSendingMessageWidget extends MessageWidget {
  String? message;
  List<File>? files;
  ChatMessageUploadController controller;
  ChatMessage? replyMessage;
  void Function(ChatMessage? replyMessage)? onClickReplyMessage;

  ChatSendingMessageWidget({
    required super.messageKey,
    required this.controller,
    this.files,
    this.message,
    this.replyMessage,
    this.onClickReplyMessage,
  });

  bool _isVideos() {
    if (!files.isFill()) return false;
    for (var file in files!) {
      if (!file.isVideo) return false;
    }
    return true;
  }

  bool _isImage() {
    if (!files.isFill()) return false;
    for (var file in files!) {
      if (!file.isImage) return false;
    }
    return true;
  }

  bool _isVoice() {
    if (!files.isFill()) return false;
    for (var file in files!) {
      if (!file.isVoice) return false;
    }
    return true;
  }

  @override
  State<ChatSendingMessageWidget> createState() {
    if (_isVoice()) {
      return ChatSendingVoiceMessageWidgetState();
    } else if (_isImage()) {
      return ChatSendingImageMessageWidgetState();
    } else if (_isVideos()) {
      return ChatSendingVideoMessageWidgetState();
    } else {
      return ChatSendingDocMessageWidgetState();
    }
  }
}

abstract class ChatSendingMessageWidgetState extends AbstractMessageWidget<ChatSendingMessageWidget> {
  String? createTime;

  @override
  void initState() {
    super.initState();

    createTime = DateFormat.Hm().format(DateTime.now());
  }

  @override
  bool isForMe() => true;

  @override
  ChatMessage? message() => null;

  bool onClickDeleteMessage(bool isForAll) {
    BlocProvider.of<ChatDeleteMessageBloc>(context).add(ChatDeleteMessageSendingEvent([widget.messageKey.key]));

    return true;
  }
}
