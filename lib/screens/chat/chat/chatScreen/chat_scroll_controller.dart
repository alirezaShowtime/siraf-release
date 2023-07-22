part of 'chat_screen.dart';

extension ChatScrollController on _ChatScreen {
  Widget ScrollDownButtonWidget() {
    return AnimatedBuilder(
      animation: _scrollDownAnimation,
      builder: (_, __) {
        return Positioned(
          right: 10,
          bottom: _scrollDownAnimation.value,
          child: FloatingActionButton(
            onPressed: scrollDown,
            child: icon(Icons.expand_more_rounded),
            elevation: 10,
            mini: true,
            backgroundColor: Colors.grey.shade50,
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
    return false;
  }

  void scrollDown({int milliseconds = 2000}) {
    try {
      _chatController.animateTo(
        _chatController.position.minScrollExtent,
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

  void scrollListener() {
    if (_chatController.position.pixels < 150) {
      _scrollDownAnimationController.reset();
      _scrollDownAnimationController.reverse();
      return;
    }

    if (_chatController.position.userScrollDirection == ScrollDirection.forward) {
      if (_scrollDownAnimation.value != end_floatingActionButtonOffset) {
        _scrollDownAnimationController.reset();
      }
      _scrollDownAnimationController.forward();
    }

    if (_chatController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_scrollDownAnimation.value != begin_floatingActionButtonOffset) {
        _scrollDownAnimationController.reset();
      }
      _scrollDownAnimationController.reverse();
    }
  }
}
