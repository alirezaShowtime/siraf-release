import 'dart:io';

import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:siraf3/controller/message_upload_controller.dart';
import 'package:siraf3/enums/message_state.dart';
import 'package:siraf3/extensions/double_extension.dart';
import 'package:siraf3/extensions/file_extension.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/screens/chat/chat/chat_message_config.dart';
import 'package:siraf3/themes.dart';

class ChatSendingMessageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatSendingMessageWidgetState();

  String? message;
  late List<File> files;
  ChatMessage? replyMessage;
  MessageUploadController controller;
  void Function(ChatMessage replyMessage)? onClickReplyMessage;

  ChatSendingMessageWidget({
    super.key,
    required this.controller,
    this.message,
    List<File>? files,
    this.replyMessage,
    this.onClickReplyMessage,
  }) {
    this.files = files ?? [];
  }
}

class ChatSendingMessageWidgetState extends State<ChatSendingMessageWidget> with SingleTickerProviderStateMixin {
  late final AnimationController loadingController = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();

  late ChatMessageConfig messageConfig;
  late String createdAt;
  late List<File> files;
  late bool hasFile;

  MessageState _messageState = MessageState.Uploading;

  MessageState get messageState => _messageState;

  void set messageState(MessageState messageState) {
    _messageState = messageState;
    setState(() {});
  }

  double nowUploadingProgress = 0;
  double countUploadingProgress = 0.1;

  double get percentUploading => (nowUploadingProgress / countUploadingProgress);

  void setUploadingProgress(double nowUploadingProgress, double countUploadingProgress) {
    this.nowUploadingProgress = nowUploadingProgress;
    this.countUploadingProgress = countUploadingProgress;
  }

  @override
  void initState() {
    super.initState();

    messageConfig = _getConfig();

    var formatter = Jalali.now();
    createdAt = "${formatter.hour}:${formatter.minute} ${formatter.year}/${formatter.month}/${formatter.day}";

    widget.controller.setChatSendingMessageWidgetState(this);

    files = widget.files;
    hasFile = widget.files.isFill();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: messageConfig.alignment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.replyMessage != null) replyWidget(widget.replyMessage!),
                for (File file in files) _getFileWidget(file),
                if (widget.message.isFill())
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, right: 5, top: hasFile ? 10 : 0),
                    child: textWidget(),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (messageState == MessageState.Uploading)
                  Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey.shade500,
                    size: 13,
                  ),
                if (messageState == MessageState.ErrorUpload)
                  Icon(
                    Icons.error_outline_rounded,
                    color: Colors.grey.shade500,
                    size: 13,
                  ),
                SizedBox(width: 2),
                Text(
                  createdAt,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 9),
                ),
              ],
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
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          child: AutoDirection(
            text: widget.message!,
            child: Text(
              widget.message!,
              style: TextStyle(color: messageConfig.textColor, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getFileWidget(File file) {
    switch (messageState) {
      case MessageState.Init:
        return _fileInitWidget(file);
      case MessageState.Uploaded:
        return _fileUploadedWidget(file);
      case MessageState.Uploading:
        return _fileUploadingWidget(file);
      case MessageState.ErrorUpload:
        return _fileErrorUpload(file);
      default:
        return Container();
    }
  }

  Widget _fileInitWidget(File file) {
    return _baseFileWidget(
      icon: Icon(Icons.arrow_downward_rounded, color: messageConfig.background, size: 30),
      fileName: file.fileName,
      fileInfo: "${file.lengthStr()}  ${file.extension}",
      onTap: () => onClickUpload(file),
    );
  }

  Widget _fileUploadedWidget(File file) {
    return _baseFileWidget(
      icon: Icon(Icons.insert_drive_file_rounded, color: messageConfig.background, size: 24),
      fileName: file.fileName,
      fileInfo: "${file.lengthStr()} ${file.extension}",
      onTap: () => onClickOpen(file),
    );
  }

  Widget _fileUploadingWidget(File file) {
    return _baseFileWidget(
      onTap: () => onClickCancel(file),
      icon: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(loadingController),
              child: CircularPercentIndicator(
                radius: 20,
                backgroundColor: Colors.transparent,
                percent: percentUploading < 0.01 ? 0.02 : percentUploading,
                animation: true,
                lineWidth: 3.5,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: messageConfig.background,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => onClickCancel(file),
              child: Icon(Icons.close_rounded, color: messageConfig.background, size: 24),
            ),
          ),
        ],
      ),
      fileName: file.fileName,
      fileInfo: "${nowUploadingProgress.toFileSize(unit: false)}/${countUploadingProgress.toFileSize()}  ${percentUploading.toInt()}%  ${file.extension}",
    );
  }

  Widget _fileErrorUpload(File file) {
    return _baseFileWidget(
      icon: Icon(Icons.refresh_rounded, color: messageConfig.background, size: 34),
      fileName: file.fileName,
      fileInfo: "${nowUploadingProgress.toFileSize()}/${countUploadingProgress.toFileSize()} ${percentUploading.toInt()}%  ${file.extension}",
      onTap: () => onClickTryAgain(file),
    );
  }

  Widget _baseFileWidget({
    required Widget icon,
    required String fileName,
    required String fileInfo,
    required Function() onTap,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: onTap,
              child: Container(
                height: 45,
                width: 45,
                margin: EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: messageConfig.primaryColor,
                ),
                child: icon,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fileName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: messageConfig.fileNameColor,
                      fontSize: 11,
                      fontFamily: "sans-serif",
                    ),
                  ),
                  Text(
                    fileInfo,
                    style: TextStyle(color: messageConfig.secondTextColor, fontSize: 9),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ChatMessageConfig _getConfig() {
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

  void onClickUpload(File file) {}

  void onClickOpen(File file) {}

  void onClickTryAgain(File file) {}

  void onClickCancel(File file) {
    widget.files.remove(file);
    widget.controller.cancelUpload();
    setState(() {});
  }

  Widget replyWidget(ChatMessage replyMessage) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onClickReplyMessage?.call(replyMessage),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 2.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(width: 5),
                Column(
                  children: [
                    Text(
                      replyMessage.forMe ? "خودم" : "مشاور",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 10,
                        fontFamily: "IranSansBold",
                      ),
                    ),
                    Text(
                      replyMessage.message!,
                      style: TextStyle(
                        color: Colors.white60,
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
