part of 'consultant_profile_screen.dart';

extension EventListener on _ConsultantProfileScreen {
  void share() {
    if (consultantInfo?.shareLink == null) return;

    push(
        context,
        ConsultantShareScreen(
          shareLink: consultantInfo!.shareLink!,
          consultantName: consultantInfo!.name!,
          consultantProfile: consultantInfo!.avatar,
          estateName: consultantInfo!.estateName!,
        ));
  }

  void viewMoreDetail({bool? force}) {
    setState(() {
      moreDetail = force ?? !moreDetail;

      if (moreDetail) {
        showCommentWidget = false;
        showSearchBarWidget = false;
      }
    });
  }

  void sendCommentOrRate(int consultantId) {
    String comment = commentController.value.text;

    bool rateIsValid = (rate ?? 0) > 0;
    // bool commentIsValid = comment.isNotEmpty;

    // if (commentIsValid && rateIsValid) {
    if (rateIsValid) {
      sendCommentRateBloc.add(ConsultantProfileCommentRateSendRateEvent(consultantId, rate!));
    } else {
      notify("امتیاز یا نظری وارد نکرده اید.");
    }
    // rate =  null;
    focusNode.unfocus();
  }

  void retry(BuildContext context) {
    BlocProvider.of<ConsultantProfileBloc>(context).add(ConsultantProfileRequestEvent(widget.consultantId));
  }

  void viewFilterFileWidget() async {
    var result = await push(
      context,
      FilterScreen(
        originalFilterData: FilterData(cityIds: [consultantInfo?.cityId ?? -1]),
        filterData: filterData,
        total_url: getFileUrl('file/files/').toString(),
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
