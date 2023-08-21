part of 'ticket_chat_screen.dart';

extension ChatScrollController on _TicketChatScreen {
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
