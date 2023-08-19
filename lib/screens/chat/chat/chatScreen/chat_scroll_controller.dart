part of 'chat_screen.dart';

extension ChatScrollController on _ChatScreen {
  Widget ScrollDownButtonWidget() {
    return AnimatedBuilder(
      animation: _scrollDownAnimation,
      builder: (_, __) {
        return Positioned(
          right: 10,
          bottom: _scrollDownAnimation.value,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: FloatingActionButton(
                  onPressed: scrollDown,
                  child: icon(Icons.expand_more_rounded),
                  elevation: 10,
                  mini: true,
                  backgroundColor: Colors.grey.shade50,
                ),
              ),
              StatefulBuilder(builder: (context, setState) {
                newMessageCountBadgeSetState = setState;
                if (newMessageCount <= 0) return SizedBox();
                return Container(
                  height: 22,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  constraints: BoxConstraints(minWidth: 22),
                  decoration: BoxDecoration(
                    color: Themes.primary,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 0),
                        color: Colors.black12,
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    newMessageCount.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontFamily: "sans-serif",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  bool onNotificationListView(Notification notification) {
    if (notification is ScrollUpdateNotification) {
      scrollDownButtonTimer?.cancel();
    }

    if (notification is ScrollEndNotification) {
      scrollDownButtonTimer = Timer(Duration(seconds: 3), () {
        _scrollDownAnimationController.reverse();
      });
    }

    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.minScrollExtent && hasNextMessage) {
        MessageWidget? lastMessage = messageWidgets.lastMessageWidget();

        if (lastMessage == null || lastMessage is! ChatMessageWidget) return false;

        chatScreenPaginationBloc.add(ChatScreenPaginationRequestEvent(
          chatId: widget.chatId,
          messageId: lastMessage.messageKey.messageId!,
          type: ChatScreenPaginationType.Next,
        ));
      }

      if (notification.metrics.pixels == notification.metrics.maxScrollExtent && hasPreviousMessage) {
        MessageWidget? firstMessage = messageWidgets.firstMessageWidget();

        if (firstMessage == null || firstMessage is! ChatMessageWidget) return false;

        chatScreenPaginationBloc.add(ChatScreenPaginationRequestEvent(
          chatId: widget.chatId,
          messageId: firstMessage.messageKey.messageId!,
          type: ChatScreenPaginationType.Previous,
        ));
      }
    }

    if (notification is UserScrollNotification) {
      scrollListener(notification.metrics, notification.direction);
    }

    return false;
  }

  void scrollDown({int milliseconds = 1500}) {
    try {
      chatItemScrollController.scrollTo(
        index: 0,
        duration: Duration(milliseconds: milliseconds),
        curve: Curves.fastOutSlowIn,
      );
      _scrollDownAnimationController.reverse();
    } catch (e) {}
  }

  void scrollTo(ChatMessage? replyMessage) {
    if (replyMessage == null) {
      return notify("پیام پاک شده است");
    }

    try {
      final index = messageWidgets.length() - 1 - messageWidgets.indexByKey(Key(replyMessage.id!.toString()));

      scrollToIndex(index);
    } catch (e) {
      return notify("پیام پاک شده است");
    }
  }

  void scrollToIndex(int index, [bool revers = false]) {
    print("scrollToIndex $index");
    chatItemScrollController.scrollTo(
      index: !revers ? index : messageWidgets.length() - 1 - index,
      duration: Duration(milliseconds: index < 20 ? 500 : 2000),
      curve: Curves.ease,
    );
  }

  void initScrollAnimation() {
    _scrollDownAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _scrollDownAnimation = Tween<double>(
      end: end_floatingActionButtonOffset,
      begin: begin_floatingActionButtonOffset,
    ).animate(_scrollDownAnimationController);
  }

  void scrollListener(ScrollMetrics scrollMetrics, ScrollDirection direction) {
    if (scrollMetrics.pixels < 150) {
      _scrollDownAnimationController.reset();
      _scrollDownAnimationController.reverse();
      return;
    }

    if (direction == ScrollDirection.forward) {
      if (_scrollDownAnimation.value != end_floatingActionButtonOffset) {
        _scrollDownAnimationController.reset();
      }
      _scrollDownAnimationController.forward();
    }

    if (direction == ScrollDirection.reverse) {
      if (_scrollDownAnimation.value != begin_floatingActionButtonOffset) {
        _scrollDownAnimationController.reset();
      }
      _scrollDownAnimationController.reverse();
    }
  }
}
