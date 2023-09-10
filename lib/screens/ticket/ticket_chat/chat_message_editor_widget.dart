import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:siraf3/bloc/ticket/sendMessage/send_message_bloc.dart';
import 'package:siraf3/extensions/file_extension.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_icon_button.dart';
import 'package:siraf3/widgets/text_field_2.dart';

class ChatMessageEditor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatMessageEditor();

  TextEditingController _messageController;

  String? replyingMessage;

  void Function(String? text, List<File>?)? onClickSendMessage;

  ChatMessageEditor({
    required TextEditingController messageController,
    this.replyingMessage,
    this.onClickSendMessage,
  }) : _messageController = messageController;
}

class _ChatMessageEditor extends State<ChatMessageEditor> with SingleTickerProviderStateMixin {
  bool showSendButton = false;

  List<File> selectedFiles = [];
  List<Widget> selectedFilesWidget = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        fileList(),
        Container(
          decoration: BoxDecoration(
            color: App.theme.dialogBackgroundColor,
            border: Border(
              top: BorderSide(color: App.theme.shadowColor, width: 0.7),
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
                decoration: BoxDecoration(color: App.theme.dialogBackgroundColor),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showSendButton || selectedFiles.isNotEmpty)
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: btn(
                          iconData: Icons.send,
                          color: App.theme.primaryColor,
                          onTap: sendMessage,
                        ),
                      ),
                    if (!showSendButton && selectedFiles.length <= 0)
                      Transform.rotate(
                        angle: 180,
                        child: btn(
                          iconData: Icons.attach_file_rounded,
                          onTap: attachFile,
                        ),
                      ),
                    if (!selectedFiles.isFill())
                      Expanded(
                        child: TextField2(
                          controller: widget._messageController,
                          maxLines: 7,
                          minLines: 1,
                          onChanged: (text) {
                            setState(() => showSendButton = text.length > 0 || selectedFiles.isNotEmpty);
                          },
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
      color: Colors.transparent,
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

  Future<void> attachFile() async {
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      await Permission.storage.request();
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;

    for (PlatformFile platformFile in result.files) {
      selectedFiles.add(File(platformFile.path!));
      selectedFilesWidget.add(attachedFileItem(File(platformFile.path!)));
    }
    setState(() {});
  }

  void sendMessage() {
    if (widget._messageController.value.text.isFill()) {
      widget.onClickSendMessage?.call(widget._messageController.value.text, null);
      widget._messageController.clear();
      setState(() {
        showSendButton = false;
      });
      return;
    }

    if (selectedFiles.isFill()) {
      widget.onClickSendMessage?.call(null, selectedFiles);
    }

    BlocProvider.of<SendMessageBloc>(context).stream.listen((state) {
      if (state is SendMessageAddedToQueue) {
        setState(() {
          selectedFilesWidget.clear();
        });
      }
      if (state is SendMessageSuccess) {
        setState(() {
          selectedFiles.clear();
        });
      }
    });
  }

  Widget fileList() {
    return Container(
      constraints: BoxConstraints(maxHeight: 300),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: App.theme.dialogBackgroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -1),
              color: App.theme.shadowColor,
              blurRadius: 5,
            )
          ]),
      child: SingleChildScrollView(
        child: Column(children: selectedFilesWidget),
      ),
    );
  }

  Widget attachedFileItem(File file) {
    var icon = Icons.insert_drive_file_rounded;
    if (file.isImage) {
      icon = Icons.image_rounded;
    } else if (file.isVoice) {
      icon = Icons.music_note_rounded;
    } else if (file.isVideo) {
      icon = Icons.videocam_rounded;
    }

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
              color: App.theme.primaryColor.withOpacity(0.1),
            ),
            child: Icon(icon, color: App.theme.primaryColor),
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
                    fontSize: 12,
                    fontFamily: "sans-serif",
                  ),
                ),
                SizedBox(height: 3),
                FutureBuilder<String>(
                  initialData: "??",
                  future: file.lengthStr(),
                  builder: (context, snapshot) {
                    return Text(
                      "${file.extension} ${snapshot.data}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        fontFamily: "sans-serif",
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          MyIconButton(
              iconData: Icons.close_rounded,
              onTap: () {
                selectedFiles.clear();
                selectedFilesWidget.clear();
                showSendButton = false;
                setState(() {});
              }),
        ],
      ),
    );
  }
}
