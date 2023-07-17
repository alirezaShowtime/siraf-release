part of 'chat_screen.dart';

extension BlocListeners on _ChatScreen {
  void chatReplyBlocListener() {
    chatReplyBloc.stream.listen((reply) {
      if (reply != null) {
        replyMessage = reply;
      }
    });
  }

  void selectMessageBlocListener() {
    selectMessageBloc.stream.listen((state) {
      if (state is SelectMessageSelectState) {
        selectedMessages.add(MapEntry(state.widgetKey, state.messageId));
        selectMessageBloc.add(SelectMessageCountEvent(selectedMessages.length));
      }

      if (state is SelectMessageDeselectState) {
        selectedMessages.removeWhere((e) => e.key == state.widgetKey);
        selectMessageBloc.add(SelectMessageCountEvent(selectedMessages.length));
      }

      if (state is SelectMessageClearState) {
        selectedMessages.clear();
        selectMessageBloc.add(SelectMessageCountEvent(0));
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

        listViewSetState?.call(
              () => messageWidgets.replace(
            i,
            ChatMessageWidget(
              key: Key(state.message.id!.toString()),
              message: state.message,
              files: state.sentFiles,
              onClickReplyMessage: scrollTo,
            ),
          ),
        );
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
