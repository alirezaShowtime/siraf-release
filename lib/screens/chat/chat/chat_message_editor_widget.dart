part of 'chat_screen.dart';

extension ChatMessageEditor on _ChatScreen {
  Widget chatMessageEditor() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        fileList(),
        BlocBuilder(
          bloc: chatReplyBloc,
          builder: (_, reply) => replyMessageWidget(reply as ChatMessage?),
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
          child: StreamBuilder<bool>(
              initialData: false,
              stream: showSendButton.stream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(color: Colors.white),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (snapshot.data == true)
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: btn(
                                iconData: Icons.send,
                                color: Themes.primary,
                                onTap: onClickSendMessage,
                              ),
                            ),
                          if (snapshot.data != true)
                            GestureDetector(
                              onHorizontalDragStart: (_) => recordingVoiceBloc.add(RecordingVoiceEvent(RecordingVoiceState.Cancel)),
                              onVerticalDragStart: (_) => recordingVoiceBloc.add(RecordingVoiceEvent(RecordingVoiceState.Cancel)),
                              child: btn(
                                iconData: Icons.keyboard_voice_outlined,
                                onTapDown: (_) => recordingVoiceBloc.add(RecordingVoiceEvent(RecordingVoiceState.Recording)),
                                onTapUp: (_) => recordingVoiceBloc.add(RecordingVoiceEvent(RecordingVoiceState.Done)),
                              ),
                            ),
                          if (snapshot.data != true)
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
                );
              }),
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
          Icon(
            Icons.reply_rounded,
            color: Themes.primary,
          ),
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
                  reply.message ?? "فایل",
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
              chatReplyBloc.add(ChatReplyEvent(null));
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;

    for (PlatformFile platformFile in result.files) {
      selectedFiles.add(File(platformFile.path!));
      selectedFilesWidget.add(attachedFileItem(File(platformFile.path!)));
    }
    fileListSetState?.call(() {});
  }

  void onClickSendMessage() {
    if (messageController.value.text.isFill() || selectedFiles.isFill()) {
      sendMessage(messageController.value.text, selectedFiles, replyMessage);
      return;
    }

    BlocProvider.of<SendMessageBloc>(context).stream.listen((state) {
      if (state is SendMessageAddedToQueue) {
        fileListSetState?.call(selectedFilesWidget.clear);
      }
      if (state is SendMessageSuccess) {
        fileListSetState?.call(selectedFiles.clear);
      }
    });
  }

  Widget fileList() {
    return StatefulBuilder(builder: (context, setState) {
      fileListSetState = setState;

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
          child: Column(children: selectedFilesWidget),
        ),
      );
    });
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
                    fontSize: 11,
                    fontFamily: "sans-serif",
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "${file.lengthStr()} ${file.extension}",
                  style: TextStyle(color: Colors.grey, fontSize: 9),
                ),
              ],
            ),
          ),
          MyIconButton(
            onTap: () {
              fileListSetState?.call(() => selectedFiles.remove(file));
            },
            iconData: Icons.close_rounded,
          ),
        ],
      ),
    );
  }
}
