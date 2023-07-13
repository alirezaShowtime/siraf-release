import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:siraf3/controller/chat_message_upload_controller.dart';
import 'package:siraf3/enums/message_state.dart';
import 'package:siraf3/extensions/file_extension.dart';
import 'package:siraf3/extensions/int_extension.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/screens/chat/chat/chat_message_config.dart';
import 'package:siraf3/screens/chat/chat/sendingMessageWidgets/chat_sending_message_widget.dart';

class ChatSendingDocMessageWidgetState extends ChatSendingMessageWidgetState {
  late final AnimationController loadingController = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();

  late ChatMessageConfig messageConfig;

  bool hasFile = false;
  bool hasText = false;

  @override
  void initState() {
    super.initState();

    messageConfig = getConfig();

    hasFile = widget.files.isFill();
    hasText = widget.message.isFill();
  }

  Widget _getFileWidget(File file) {
    return StreamBuilder<MessageState>(
      initialData: MessageState.Init,
      stream: widget.controller.messageSate.stream,
      builder: (_, snapshot) {
        switch (snapshot.data) {
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
      },
    );
  }

  Widget _fileInitWidget(File file) {
    return _baseFileWidget(
      icon: Icon(Icons.arrow_downward_rounded, color: messageConfig.background, size: 24),
      fileName: file.fileName,
      fileInfo: "${file.lengthStr()}  ${file.extension}",
    );
  }

  Widget _fileUploadedWidget(File file) {
    return _baseFileWidget(
      icon: Icon(Icons.insert_drive_file_rounded, color: messageConfig.background, size: 24),
      fileName: file.fileName,
      fileInfo: "${file.lengthStr()} ${file.extension}",
    );
  }

  Widget _fileUploadingWidget(File file) {
    return StreamBuilder<UploadingDetail>(
        initialData: UploadingDetail(0, 0),
        stream: widget.controller.uploading.stream,
        builder: (context, snapshot) {
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
                      percent: snapshot.data!.percent < 0.01 ? 0.02 : snapshot.data!.percent,
                      lineWidth: 3.5,
                      animation: false,
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
            fileInfo: "${snapshot.data!.uploaded.toFileSize(unit: false)}/${snapshot.data!.uploaded.toFileSize()}  ${snapshot.data!.percentStr}  ${file.extension}",
          );
        });
  }

  Widget _fileErrorUpload(File file) {
    return StreamBuilder<UploadingDetail>(
      initialData: UploadingDetail(0, 0),
      stream: widget.controller.uploading.stream,
      builder: (context, snapshot) {
        return _baseFileWidget(
          icon: Icon(Icons.refresh_rounded, color: messageConfig.background, size: 34),
          fileName: file.fileName,
          fileInfo: "${snapshot.data!.uploaded.toFileSize()}/${snapshot.data!.count.toFileSize()} ${snapshot.data!.percentStr}%  ${file.extension}",
          onTap: () => onClickTryAgain(file),
        );
      },
    );
  }

  Widget _baseFileWidget({required Widget icon, required String fileName, required String fileInfo, Function()? onTap}) {
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
                    style: TextStyle(color: messageConfig.secondTextColor, fontSize: 8, fontFamily: "sans-serif", fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onClickTryAgain(File file) {}

  void onClickCancel(File file) {
    widget.files!.remove(file);
    widget.controller.cancelUpload();
    setState(() {});
  }

  @override
  Widget content() {
    return widget.message.isFill() ? textAndFileWidget() : fileWidget();
  }

  Widget textAndFileWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        replyWidget(widget.replyMessage, widget.onClickReplyMessage),
        if (hasFile)
          for (File file in widget.files!) _getFileWidget(file),
        if (hasText && hasFile) textWidget(widget.message, marginVertical: 0),
        if (hasFile) customFooter(),
        if (!hasFile)
          Wrap(
            verticalDirection: VerticalDirection.up,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              customFooter(),
              if (hasText) textWidget(widget.message),
            ],
          ),
      ],
    );
  }

  Widget customFooter() {
    return StreamBuilder<MessageState>(
      initialData: MessageState.Uploading,
      stream: widget.controller.messageSate.stream,
      builder: (context, snapshot) {
        return footerWidget(
          false,
          createTime ?? "",
          sending: snapshot.data == MessageState.Uploading,
          error: snapshot.data == MessageState.ErrorUpload,
        );
      },
    );
  }

  Widget fileWidget() {
    return Stack(
      children: [
        Column(
          children: [
            replyWidget(widget.replyMessage, widget.onClickReplyMessage),
            for (File file in widget.files!) _getFileWidget(file),
          ],
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: customFooter(),
        )
      ],
    );
  }
}
