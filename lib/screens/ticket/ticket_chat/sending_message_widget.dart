import 'dart:io';

import 'package:auto_direction/auto_direction.dart';
import 'package:siraf3/controller/message_upload_controller.dart';
import 'package:siraf3/enums/message_state.dart';
import 'package:siraf3/extensions/double_extension.dart';
import 'package:siraf3/extensions/file_extension.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/ticket/ticket_chat/message_config.dart';
import 'package:siraf3/themes.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shamsi_date/shamsi_date.dart';

class SendingMessageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SendingMessageWidgetState();

  String message;
  late List<File> files;
  MessageUploadController controller;

  SendingMessageWidget({super.key, required this.controller, required this.message, List<File>? files}) {
    this.files = files ?? [];
  }
}

class SendingMessageWidgetState extends State<SendingMessageWidget> with SingleTickerProviderStateMixin {
  late final AnimationController loadingController = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();

  late MessageConfig messageConfig;
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

    widget.controller.setSendingMessageWidgetState(this);

    files = widget.files;
    hasFile = widget.files.isFill();
  }

  @override
  Widget build(BuildContext context) {
    if (files.isNotEmpty) return uploadingMessageWidget();

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
            child: textWidget(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
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

  Widget uploadingMessageWidget() {
    return Container(
      alignment: messageConfig.alignment,
      margin: EdgeInsets.only(bottom: 3, left: 5, right: 5),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: messageConfig.background,
              borderRadius: messageConfig.borderRadius,
            ),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            margin: EdgeInsets.only(bottom: 3, left: 10, right: 10),
            padding: EdgeInsets.only(top: 5, left: 9, right: 9, bottom: 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (File file in files)
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          file.fileName,
                          textDirection: TextDirection.ltr,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: messageConfig.fileNameColor,
                            fontSize: 10,
                            fontFamily: "sans-serif",
                          ),
                        ),
                        Text(
                          "${file.lengthStr()} ${file.extension}",
                          style: TextStyle(color: messageConfig.secondTextColor, fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                if (widget.message.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, right: 5, top: hasFile ? 10 : 0),
                    child: textWidget(),
                  ),
                if (messageState == MessageState.Uploading)
                  Icon(
                    Icons.access_time_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                if (messageState == MessageState.ErrorUpload)
                  Icon(
                    Icons.error_outline_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: LinearPercentIndicator(
                    isRTL: true,
                    backgroundColor: Colors.black12,
                    animation: true,
                    barRadius: Radius.circular(10),
                    progressColor: Colors.black.withOpacity(1),
                    lineHeight: 7,
                    padding: EdgeInsets.only(left: 3),
                    percent: percentUploading < 0.01 ? 0.01 : percentUploading,
                  ),
                ),
                Text(
                  "${nowUploadingProgress.toFileSize(unit: false)}/${countUploadingProgress.toFileSize()}  ${(percentUploading * 100).toInt()}%",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                    fontFamily: "sans-serif",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 10),
            child: Text(
              createdAt,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 9, height: 1),
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
            text: widget.message,
            child: Text(
              widget.message,
              style: TextStyle(color: messageConfig.textColor, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _getFileWidget(File file) {
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
        return null;
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
            child: Icon(Icons.close_rounded, color: messageConfig.background, size: 24),
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
                      fontSize: 14,
                      fontFamily: "sans-serif",
                      fontWeight: FontWeight.w600,
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

  MessageConfig _getConfig() {
    return MessageConfig(
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
    setState(() {});
  }
}
