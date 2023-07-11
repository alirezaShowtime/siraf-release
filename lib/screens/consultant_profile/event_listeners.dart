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

    bool rateIsValid = (rate ?? 0) > 0;
    bool commentIsValid = comment.isNotEmpty;

    //if true, the comment and the rate will be sent
    if (commentIsValid && rateIsValid) {
      sendCommentRateBloc.add(ConsultantProfileCommentRateSendCommentAndRateEvent(consultantId, rate!, comment));
    }

    //if true, only the comment will be sent
    if (commentIsValid && !rateIsValid) {
      sendCommentRateBloc.add(ConsultantProfileCommentRateSendCommentEvent(consultantId, comment));
    }

    //if true, ony the rate will be sent
    if (!commentIsValid && rateIsValid) {
      sendCommentRateBloc.add(ConsultantProfileCommentRateSendRateEvent(consultantId, rate!));
    }
  }

  void retry(BuildContext context) {
    BlocProvider.of<ConsultantProfileBloc>(context).add(ConsultantProfileRequestEvent(widget.consultantId));
  }

  void viewFilterFileWidget() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(
          originalFilterData: FilterData(cityIds: [consultantInfo?.cityId ?? -1]),
          filterData: filterData,
          total_url: getFileUrl('file/files/').toString(),
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
