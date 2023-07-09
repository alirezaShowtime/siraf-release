part of 'consultant_profile_screen.dart';

extension EventListener on _ConsultantProfileScreen {
  void share() {
    FlutterShare.share(
      title: 'اشتراک گذاری',
      text: consultantInfo?.name ?? '',
      linkUrl: consultantInfo?.shareLink,
      chooserTitle: 'اشتراک گذاری در',
    );
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
        collapseController.forward();
      } else {
        collapseController.reverse();
      }
    });
  }

  void sendCommentOrRate(int consultantId) {
    String comment = commentController.value.text;

    bool rateIsValid = (rating ?? 0) > 0;
    bool commentIsValid = comment.isNotEmpty;

    //if true, the comment and the rate will be sent
    if (commentIsValid && rateIsValid) {
      BlocProvider.of<ConsultantProfileBloc>(context).add(ConsultantProfileSendComment(massage: comment, consultantId: consultantId));
    }

    //if true, only the comment will be sent
    if (commentIsValid && !rateIsValid) {
      BlocProvider.of<ConsultantProfileBloc>(context).add(ConsultantProfileSendComment(massage: comment, consultantId: consultantId));
    }

    //if true, ony the rate will be sent
    if (!commentIsValid && rateIsValid) {
      BlocProvider.of<ConsultantProfileBloc>(context).add(ConsultantProfileSendRate(rate: rating!, consultantId: consultantId));
    }
  }

  void retry(BuildContext context) {
    BlocProvider.of<ConsultantProfileBloc>(context).add(ConsultantProfileLoad(widget.consultantId));
  }

  void viewFilterFileWidget() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(
          originalFilterData:
              FilterData(cityIds: [consultantInfo?.cityId ?? -1]),
          filterData: filterData,
        ),
      ),
    );

    if (result != null && result is FilterData) {
      setState(() {
        result.consultantId = widget.consultantId;
        filterData = result;
      });

      print(filterData.toQueryString());

      getFiles();
    }
  }

  void report() {
    callToSupport();
  }
}
