part of 'chat_screen.dart';

extension BlocListeners on _ChatScreen {
  void deleteMessageBlocListener() {
    chatDeleteMessageBloc.stream.listen((state) {
      if (state is ChatDeleteMessageSending) {
        for (Key wKey in state.widgetKeys) {
          messageWidgets.removeWhere((e) => e.key == wKey);
        }
        if (messageWidgets.widgetLength() > 0) {
          listViewSetState?.call(() {});
        } else {
          setState(() {});
        }
        return;
      }

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
        await startRecording();
        startTimer();
      }
      if (state == RecordingVoiceState.Done) {
        try {
          var path = await stopRecording();

          if (recordTime < 1) return;

          endTimer();
          sendMessage(null, [File(path!)], replyMessage);
        } catch (e) {}
      }
    });
  }

  void chatMessagesBlocListener() {
    chatMessagesBloc.stream.listen((state) {
      if (state is! MessagesSuccess) return;

      var notSeen = state.messages.where((e) => !e.isSeen).length;

      if (state.newMessageCount > notSeen) {
        newMessageCount = state.newMessageCount - notSeen;
        newMessageCountBadgeSetState?.call(() {});
        hasNextMessage = true;
      }

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => scrollDown());
    });
  }

  void sendMessageBlocListener() {
    sendMessageBloc.stream.listen((state) {
      if (state is SendMessageCanceled) {
        for (var w in messageWidgets.getList()) {
          if (state.widgetKeys.contains(w.key)) {
            messageWidgets.removeWhere((e) => e.key == w.key);
          }
        }
        listViewSetState?.call(() {});
      }

      if (state is SendMessageForbiddenAccess) {
        blockByHer = true;
        setState(() {});
        return;
      }

      if (state is! SendMessageSuccess) return;
      state.playSentSound();
      for (var i = 0; i < messageWidgets.length(); i++) {
        if (messageWidgets.get(i).key != state.widgetKey) continue;

        lastMessage = state.message;

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
        Navigator.pop(context, {
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
        errorDialog(context: context, message: state.message);
      }

      if (state is ChatBlockSuccess) {
        dismissDialog(loadingDialogContext);
        try {
          setState(() => isBlockByMe = state.isBlock);
        } catch (e) {}
      }
    });
  }

  void chatMessageSearchBlocListener() {
    chatMessageSearchBloc.stream.listen((state) {
      if (state is! ChatMessageSearchSuccess) return;

      hasNextMessage = true;

      if (!state.messages.isFill()) {
        showSearchResult = false;
        return;
      } else {
        if (state.type == MessageSearchType.Next && (lastMessage?.id ?? 0) < state.messages.first.id!) {
          // lastMessage = state.messages.first;
          hasNextMessage = state.messages.first.isSeen;
        }

        showSearchResult = true;
      }

      messageWidgets.clearList();
      List<MapEntry<int, int>> found = [];

      for (var message in state.messages.reversed) {
        var widget = ChatMessageWidget(
          message: message,
          onClickReplyMessage: scrollTo,
          messageKey: MessageWidgetKey(message),
        );
        messageWidgets.add(createDate: message.createDate!, widget: widget);
        if (message.message?.contains(state.searched) ?? false) {
          found.add(MapEntry(messageWidgets.indexByKey(widget.key!), message.id!));
        }
      }

      if (state.countSearch != null) {
        countSearch = state.countSearch!;
      }

      listViewSetState?.call(() {});

      if (state.type == null) {
        currentFoundedIndex = null;
      }

      if (found.isFill()) {
        if (state.type == null) {
          foundMessageWidgetIndexes.setList(found.reversed.toList());
          scrollToIndex(found.last.key, true);
          currentFoundedIndex = null;
        } else if (state.type == MessageSearchType.Next) {
          foundMessageWidgetIndexes.setList(found.reversed.toList());
          scrollToIndex(found.last.key, true);
        } else if (state.type == MessageSearchType.Previous) {
          foundMessageWidgetIndexes.setList(found.reversed.toList(), true);
          scrollToIndex(found.first.key, true);
        }
      }
    });
  }

  void paginationBlocListener() {
    chatScreenPaginationBloc.stream.listen((state) {
      if (state is! ChatScreenPaginationSuccess) return;

      if (state.messages.isEmpty) {
        if (state.type == ChatScreenPaginationType.Previous) {
          hasPreviousMessage = false;
        }
        if (state.type == ChatScreenPaginationType.Next) {
          hasNextMessage = false;
        }
        return;
      }

      var notSeen = state.messages.where((e) => !e.isSeen).length;

      if (state.type == ChatScreenPaginationType.Next && notSeen > 0) {
        newMessageCount -= notSeen;
        newMessageCountBadgeSetState?.call(() {});
      }

      for (var message in state.type == ChatScreenPaginationType.Next ? state.messages.reversed : state.messages) {
        var widget = ChatMessageWidget(
          messageKey: MessageWidgetKey(message),
          message: message,
          onClickReplyMessage: scrollTo,
        );

        if (state.type == ChatScreenPaginationType.Previous) {
          messageWidgets.shift(createDate: message.createDate!, widget: widget);
        }

        if (state.type == ChatScreenPaginationType.Next) {
          messageWidgets.add(createDate: message.createDate!, widget: widget);
        }
      }
      listViewSetState?.call(() {});
    });
  }
}
