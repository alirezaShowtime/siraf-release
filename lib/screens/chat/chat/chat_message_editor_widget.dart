import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/chat/recordingVoice/recording_voice_bloc.dart';
import 'package:siraf3/bloc/chat/reply/chat_reply_bloc.dart';
import 'package:siraf3/extensions/file_extension.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_icon_button.dart';
import 'package:siraf3/widgets/text_field_2.dart';

class ChatMessageEditor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatMessageEditor();

  void Function(String? text, List<File>? files, ChatMessage? replyMessage)? onClickSendMessage;

  ChatMessageEditor({this.onClickSendMessage});
}

class _ChatMessageEditor extends State<ChatMessageEditor> {
  List<File> selectedFiles = [];
  List<Widget> selectedFileWidgets = [];
  bool showReplyMessage = false;
  bool showSendButton = false;
  TextEditingController messageController = TextEditingController();

  ChatMessage? replyMessage;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<ChatReplyBloc>(context).stream.listen((ChatMessage? reply) {
      replyMessage = reply;
      FocusManager.instance.primaryFocus?.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        fileList(),
        BlocBuilder<ChatReplyBloc, ChatMessage?>(
          builder: (_, reply) => replyMessageWidget(reply),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade300, width: 0.7)),
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
                    if (showSendButton)
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: btn(
                          iconData: Icons.send,
                          color: Themes.primary,
                          onTap: onClickSendMessage,
                        ),
                      ),
                    if (!showSendButton)
                      GestureDetector(
                        onHorizontalDragStart: (_) => BlocProvider.of<RecordingVoiceBloc>(context).add(RecordingVoiceEvent(RecordingVoiceState.Cancel)),
                        onVerticalDragStart: (_) => BlocProvider.of<RecordingVoiceBloc>(context).add(RecordingVoiceEvent(RecordingVoiceState.Cancel)),
                        child: btn(
                          iconData: Icons.keyboard_voice_outlined,
                          onTapDown: (_) => BlocProvider.of<RecordingVoiceBloc>(context).add(RecordingVoiceEvent(RecordingVoiceState.Recording)),
                          onTapUp: (_) => BlocProvider.of<RecordingVoiceBloc>(context).add(RecordingVoiceEvent(RecordingVoiceState.Done)),
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
                    Expanded(
                      child: TextField2(
                        controller: messageController,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget replyMessageWidget(ChatMessage? reply) {
    if (reply == null) return Container();
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 5, right: 8, top: 5, bottom: 5),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.reply_rounded, color: Themes.primary),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reply.forMe == true ? "خودم" : "مشاور",
                  style: TextStyle(
                    fontFamily: "IranSansBold",
                    color: Themes.primary,
                    fontSize: 10,
                  ),
                ),
                Text(
                  _replyMessage(reply),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Themes.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          MyIconButton(
            icon: Icon(Icons.close_rounded, color: Themes.text),
            onTap: () {
              BlocProvider.of<ChatReplyBloc>(context).add(ChatReplyEvent(null));
            },
          ),
        ],
      ),
    );
  }

  Widget btn({
    required IconData iconData,
    Function()? onTap,
    Color? color,
    void Function(TapDownDetails)? onTapDown,
    void Function(TapUpDetails)? onTapUp,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
          child: icon(iconData, color: color ?? Colors.grey.shade400),
        ),
      ),
    );
  }

  Future<void> attachFile() async {
    selectedFiles.clear();
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;

    for (PlatformFile platformFile in result.files) {
      selectedFiles.add(File(platformFile.path!));
      selectedFileWidgets.add(attachedFileItem(File(platformFile.path!)));
    }
    showSendButton = true;
    setState(() {});
  }

  void onClickSendMessage() {
    var text = messageController.value.text;
    if (!text.isFill() && !selectedFiles.isFill()) return;

    widget.onClickSendMessage?.call(text.isEmpty ? null : text, selectedFiles, replyMessage);
    showSendButton = false;
    messageController.clear();
    setState(selectedFileWidgets.clear);
  }

  Widget fileList() {
    return Container(
      constraints: BoxConstraints(maxHeight: 300),
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
        ],
      ),
      child: SingleChildScrollView(
        child: Column(children: selectedFileWidgets),
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
              color: Themes.primary.withOpacity(0.1),
            ),
            child: Icon(icon, color: Themes.primary),
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
                    fontSize: 11,
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
                        fontSize: 9,
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
              selectedFileWidgets.clear();
              showSendButton = false;

              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  String _replyMessage(ChatMessage replyMessage) {
    switch (replyMessage.getTypeFile()) {
      case TypeFile.Image:
        return "عکس";
      case TypeFile.Video:
        return "ویدیو";
      case TypeFile.Voice:
        return "صدا";
      case TypeFile.Doc:
        return replyMessage.message ?? "";
      default:
        return replyMessage.message ?? "";
    }
  }
}
