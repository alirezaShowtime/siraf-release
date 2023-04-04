part of 'agent_profile_screen.dart';

extension EventListener on _AgentProfileScreen {
  void share() {
    //todo: implement event listener
  }

  void like(Comment comment) {
    //todo: the endpoint to like comment is`t implement
    //todo: implement event listener
  }

  void answer(Comment comment) {
    //todo: the endpoint to like comment is`t implement
    //todo: implement event listener
  }

  void dislike(Comment comment) {
    //todo: the endpoint to like comment is`t implement
    //todo: implement event listener
  }

  void viewMoreDetail({bool? force}) {
    setState(() {
      moreDetail = force ?? !moreDetail;

      if (moreDetail) {
        showCommentWidget = false;
        showSearchBarWidget = false;
        collopsController.forward();
      } else {
        collopsController.reverse();
      }
    });
  }

  void sendCommentOrRate(int consultantId) {
    String comment = commentController.value.text;

    bool rateIsValid = (rating ?? 0) > 0;
    bool commentIsValid = comment.isNotEmpty;

    //if true, the comment and the rate will be sent
    if (commentIsValid && rateIsValid) {
      BlocProvider.of<AgentProfileBloc>(context).add(AgentProfileSendComment(massage: comment, consultantId: consultantId));
    }

    //if true, only the comment will be sent
    if (commentIsValid && !rateIsValid) {
      BlocProvider.of<AgentProfileBloc>(context).add(AgentProfileSendComment(massage: comment, consultantId: consultantId));
    }

    //if true, ony the rate will be sent
    if (!commentIsValid && rateIsValid) {
      BlocProvider.of<AgentProfileBloc>(context).add(AgentProfileSendRate(rate: rating!, consultantId: consultantId));
    }
  }

  void retry(BuildContext context) {
    BlocProvider.of<AgentProfileBloc>(context).add(AgentProfileLoad(widget.consultantId));
  }

  void viewFilterFileWidget() {}

  void report() {}
}
