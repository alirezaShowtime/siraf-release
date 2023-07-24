import 'dart:async';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  void Function(bool isOpenEmojiKeyboard)? onOpenEmojiKeyboard;

  StreamController<bool>? changeKeyboardStatus;

  ChatMessageEditor({this.onClickSendMessage, this.onOpenEmojiKeyboard, this.changeKeyboardStatus});
}

class _ChatMessageEditor extends State<ChatMessageEditor> {
  List<File> selectedFiles = [];
  List<Widget> selectedFileWidgets = [];
  bool showReplyMessage = false;
  bool showSendButton = false;
  TextEditingController messageController = TextEditingController();

  ChatMessage? replyMessage;

  bool openEmojiKeyboard = false;
  bool keyboardIsHidden = true;

  FocusNode focusNode = FocusNode();
  bool keyboardIsFocused = false;
  double keyboardHeight = 0.0;
  bool hiddenKeyboardByEmoji = false;
  bool isTextRtl = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<ChatReplyBloc>(context).stream.listen((ChatMessage? reply) {
      replyMessage = reply;
      FocusManager.instance.primaryFocus?.requestFocus();
    });

    messageController.addListener(() {
      var text = messageController.value.text;
      var now = text.length > 0 || selectedFiles.isNotEmpty;
      if (showSendButton != now) {
        showSendButton = now;
        try {
          setState(() {});
        } catch (e) {}
      }
    });

    widget.changeKeyboardStatus?.stream.listen((status) {
      if (openEmojiKeyboard != status) {
        openEmojiKeyboard = status;
        widget.onOpenEmojiKeyboard?.call(openEmojiKeyboard);
        try {
          setState(() {});
        } catch (e) {}
      }
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
              StatefulBuilder(builder: (context, containerSetState) {
                return Container(
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
                          onHorizontalDragStart: (_) => cancelRecord(),
                          onVerticalDragStart: (_) => cancelRecord(),
                          child: btn(
                            onTapDown: (_) => startRecord(),
                            onTapUp: (_) => stopRecord(),
                            onTapCancel: () => stopRecord(),
                            iconData: Icons.keyboard_voice_outlined,
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
                          onTap: () {
                            if (!openEmojiKeyboard) {
                              keyboardIsHidden = false;
                              openEmojiKeyboard = true;
                              widget.onOpenEmojiKeyboard?.call(openEmojiKeyboard);
                              setState(() {});
                            }
                          },
                          controller: messageController,
                          focusNode: focusNode,
                          showCursor: true,
                          readOnly: keyboardIsHidden,
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
                      //   iconData: keyboardIsHidden && openEmojiKeyboard ? Icons.keyboard_outlined : Icons.mood_rounded,
                      //   onTap: () {
                      //     if (!openEmojiKeyboard) {
                      //       openEmojiKeyboard = true;
                      //       focusNode.requestFocus();
                      //       widget.onOpenEmojiKeyboard?.call(openEmojiKeyboard);
                      //       setState(() {});
                      //     }
                      //
                      //     keyboardIsHidden = !keyboardIsHidden;
                      //     if (keyboardIsHidden) {
                      //       hiddenKeyboardByEmoji = true;
                      //     }
                      //     containerSetState(() {});
                      //   },
                      // ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        if (openEmojiKeyboard && false)
          EmojiPicker(
            textEditingController: messageController,
            config: Config(
              columns: 10,
              emojiSizeMax: 24 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
              verticalSpacing: 0,
              horizontalSpacing: 0,
              gridPadding: EdgeInsets.zero,
              initCategory: Category.RECENT,
              bgColor: Colors.white,
              indicatorColor: Themes.primary,
              iconColor: Colors.grey.shade400,
              iconColorSelected: Themes.primary,
              backspaceColor: Themes.primary,
              skinToneDialogBgColor: Colors.white,
              skinToneIndicatorColor: Colors.grey.shade300,
              enableSkinTones: true,
              recentTabBehavior: RecentTabBehavior.RECENT,
              recentsLimit: 28,
              replaceEmojiOnLimitExceed: true,
              noRecents: const Text(
                'No Recents',
                style: TextStyle(fontSize: 20, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              loadingIndicator: SpinKitRing(
                color: Themes.primary,
                size: 25,
                lineWidth: 4,
              ),
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(
                recentIcon: Icons.access_time_rounded,
                smileyIcon: Icons.tag_faces_outlined,
                animalIcon: Icons.pets_rounded,
                foodIcon: Icons.fastfood_rounded,
                activityIcon: Icons.directions_run_rounded,
                travelIcon: Icons.location_city_rounded,
                objectIcon: Icons.lightbulb_outline_rounded,
                symbolIcon: Icons.emoji_symbols_rounded,
                flagIcon: Icons.flag_rounded,
              ),
              buttonMode: ButtonMode.MATERIAL,
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
    void Function()? onTapCancel,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: onTapCancel,
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
    try {
      setState(() {});
    } catch (e) {}
  }

  void onClickSendMessage() {
    var text = messageController.value.text;
    if (!text.isFill() && !selectedFiles.isFill()) return;

    widget.onClickSendMessage?.call(text.isEmpty ? null : text, selectedFiles, replyMessage);
    showSendButton = false;
    messageController.clear();
    // selectedFiles.clear();
    selectedFileWidgets.clear();
    try {
      setState(() {});
    } catch (e) {}
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
              try {
                setState(() {});
              } catch (e) {}
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

  void cancelRecord() {
    timer?.cancel();
    if (BlocProvider.of<RecordingVoiceBloc>(context).state == RecordingVoiceState.Recording) {
      BlocProvider.of<RecordingVoiceBloc>(context).add(RecordingVoiceEvent(RecordingVoiceState.Cancel));
    }
  }

  Future<void> startRecord() async {
    timer = Timer(Duration(milliseconds: 800), () {
      if (BlocProvider.of<RecordingVoiceBloc>(context).state != RecordingVoiceState.Recording) {
        BlocProvider.of<RecordingVoiceBloc>(context).add(RecordingVoiceEvent(RecordingVoiceState.Recording));
      }
    });
  }

  void stopRecord() {
    timer?.cancel();
    if (BlocProvider.of<RecordingVoiceBloc>(context).state == RecordingVoiceState.Recording) {
      BlocProvider.of<RecordingVoiceBloc>(context).add(RecordingVoiceEvent(RecordingVoiceState.Done));
    }
  }
}
