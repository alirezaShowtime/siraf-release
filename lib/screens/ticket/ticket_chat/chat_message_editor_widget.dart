import 'dart:io';

import 'package:siraf3/extensions/file_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_icon_button.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ChatMessageEditor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatMessageEditor();

  TextEditingController _messageController;

  //todo: type of the replayingMessage variable is a test type, this variable is possible a model class
  String? replyingMessage;

  //todo: type of the onSendMessage variable is a test type, this variable is possible a model class
  void Function(String text, List<File>)? onClickSendMessage;
  void Function()? onRecordVoice;
  void Function()? onAttachEmoji;
  void Function()? onAttachFile;

  ChatMessageEditor({
    required TextEditingController messageController,
    this.replyingMessage,
    this.onClickSendMessage,
    this.onAttachEmoji,
    this.onAttachFile,
  }) : _messageController = messageController;
}

class _ChatMessageEditor extends State<ChatMessageEditor> with SingleTickerProviderStateMixin {
  bool showSendButton = false;

  List<File> selectedFiles = [];

  @override
  void initState() {
    super.initState();
    widget._messageController.addListener(_messageControlListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget._messageController.removeListener(_messageControlListener);
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
    return Column(
      children: [
        fileList(),
        Container(
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
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showSendButton || selectedFiles.isNotEmpty)
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: btn(
                          iconData: Icons.send,
                          color: Themes.primary,
                          onTap: sendMessage,
                        ),
                      ),
                    if (!showSendButton)
                      Transform.rotate(
                        angle: 180,
                        child: btn(
                          iconData: Icons.attach_file_rounded,
                          onTap: attachFile,
                        ),
                      ),
                    // if (!showSendButton)
                    //   btn(
                    //     iconData: Icons.keyboard_voice_outlined,
                    //     onTap: recordVoice,
                    //   ),
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
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    // btn(
                    //   iconData: Icons.sentiment_satisfied_rounded,
                    //   onTap: attachEmoji,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget btn({required IconData iconData, required Function() onTap, Color? color}) {
    return Material(
      color: Themes.background2,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: icon(iconData, color: color ?? Colors.grey.shade400),
        ),
      ),
    );
  }

  //event listeners
  void attachEmoji() {
    //todo: implement event listener
    widget.onAttachEmoji?.call();
  }

  Future<void> attachFile() async {
    widget.onAttachFile?.call();

    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result == null) return;

    for (PlatformFile platformFile in result.files) {
      selectedFiles.add(File(platformFile.path!));
    }
    setState(() {});
  }

  void recordVoice() {
    //todo: implement event listener
    widget.onRecordVoice?.call();
  }

  void sendMessage() {
    // FocusManager.instance.primaryFocus?.unfocus();
    widget.onClickSendMessage?.call(widget._messageController.value.text, selectedFiles);
    widget._messageController.text = '';

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        selectedFiles.clear();
      });
    });

    // BlocProvider.of<SendMessageBloc>(context).stream.listen((state) {
    //   if (state is SendMessageAddedToQueue) {
    //    setState(() {
    //      selectedFiles.clear();
    //    });
    //   }
    // });
  }

  Widget fileList() {
    return Container(
      constraints: BoxConstraints(maxHeight: 300),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -1),
              color: Colors.black12,
              blurRadius: 5,
            )
          ]),
      child: SingleChildScrollView(
        child: Column(
          children: selectedFiles.map((file) => attachedFileItem(file)).toList(),
        ),
      ),
    );
  }

  Widget attachedFileItem(File file) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 7),
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            margin: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Themes.primary.withOpacity(0.2),
            ),
            child: Icon(
              Icons.insert_drive_file_rounded,
              color: Themes.primary.withOpacity(0.6),
              size: 30,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.fileName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: "sans-serif",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "${file.lengthStr()} ${file.extension}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          MyIconButton(
            onTap: () {
              setState(() => selectedFiles.remove(file));
            },
            iconData: Icons.close_rounded,
          ),
        ],
      ),
    );
  }
}
