part of 'chat_screen.dart';

extension BlocListeners on _ChatScreen {
  void deleteMessageBlocListener() {
    chatDeleteMessageBloc.stream.listen((state) {
      if (state is ChatDeleteMessageLoading) {
        loadingDialog(context: context);
      }
      if (state is ChatDeleteMessageError) {
        dismissDialog(loadingDialogContext);
        errorDialog(context: context);
      }
      if (state is ChatDeleteMessageSuccess) {
        dismissDialog(loadingDialogContext);
        notify("با موفقیت حذف شد.");

        selectMessageBloc.add(SelectMessageClearEvent());

        for (int messageId in state.ids) {
          messageWidgets.removeWhere((e) => e.equalTo(messageId));
        }

        if (messageWidgets.widgetLength() > 0) {
          listViewSetState?.call(() {});
        } else {
          print("fdfsdfsdrkdpriwedrp[eor]");
          setState(() {});
        }
      }
    });
  }

  void chatReplyBlocListener() {
    chatReplyBloc.stream.listen((reply) {
      if (reply != null) {
        replyMessage = reply;
      }
    });
  }

  void recordingVoiceBlocListener() {
    recordingVoiceBloc.stream.listen((state) async {
      if (state == RecordingVoiceState.Cancel) {
        await cancelRecording();
        endTimer();
      }
      if (state == RecordingVoiceState.Recording) {
        print("status record! start");
        await startRecording();
        startTimer();
      }
      if (state == RecordingVoiceState.Done) {
        try {
          print("status record! stop");
          var path = await stopRecording();

          if (recordTime < 1) return;

          endTimer();
          sendMessage(null, [File(path!)], replyMessage);
        } catch (e) {}
      }
    });
  }

  void chatMessagesBlocListener() {
    chatMessagesBloc.stream.listen((event) {
      if (event is! MessagesSuccess) return;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => scrollDown());
    });
  }

  void sendMessageBlocListener() {
    sendMessageBloc.stream.listen((state) {
      if (state is SendMessageCanceled) {
        for (var i = 0; i < messageWidgets.length(); i++) {
          if (messageWidgets.get(i).key != state.widgetKey) continue;

          listViewSetState?.call(() => messageWidgets.removeAt(i));

          break;
        }
      }

      if (state is! SendMessageSuccess) return;
      state.playSentSound();
      for (var i = 0; i < messageWidgets.length(); i++) {
        if (messageWidgets.get(i).key != state.widgetKey) continue;

        lastMessage = state.message.message;

        messageWidgets.replace(
          i,
          ChatMessageWidget(
            messageKey: MessageWidgetKey(state.message),
            message: state.message,
            files: state.sentFiles,
            onClickReplyMessage: scrollTo,
          ),
        );

        try {
          if (messageWidgets.widgetLength() == 1) {
            setState(() {});
          } else {
            listViewSetState?.call(() {});
          }
        } catch (e) {}

        break;
      }
    });
  }

  void chatDeleteBlocListener() {
    chatDeleteBloc.stream.listen((state) {
      if (state is ChatDeleteLoading) {
        loadingDialog(context: context);
      }

      if (state is ChatDeleteError) {
        dismissDialog(loadingDialogContext);
        errorDialog(context: context);
      }

      if (state is ChatDeleteSuccess) {
        dismissDialog(loadingDialogContext);
        back(context, {
          "chatId": widget.chatId,
          "deleted": true,
        });
      }
    });
  }

  void chatBlockBlocListener() {
    chatBlockBloc.stream.listen((state) {
      if (state is ChatBlockLoading) {
        loadingDialog(context: context);
      }

      if (state is ChatBlockError) {
        dismissDialog(loadingDialogContext);
        errorDialog(context: context);
      }

      if (state is ChatBlockSuccess) {
        dismissDialog(loadingDialogContext);
        try {
          setState(() => isBlockByMe = state.isBlock);
        } catch (e) {}
      }
    });
  }
}
