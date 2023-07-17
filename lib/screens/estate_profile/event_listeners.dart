part of 'package:siraf3/screens/estate_profile/estate_profile_screen.dart';

extension EventListener on _EstateProfileScreen {
  void share() {
    if (estateProfile?.shareLink == null) return;

    FlutterShare.share(
      title: 'اشتراک گذاری',
      text: estateProfile!.name!,
      linkUrl: estateProfile!.shareLink,
      chooserTitle: 'اشتراک گذاری در',
    );
  }

  void openFileBox() async {
    var result = await push(
      context,
      FilterScreen(
        originalFilterData: FilterData(cityIds: cities.map<int>((e) => e.id!).toList()),
        filterData: filterData,
        total_url: getFileUrl('file/files/').toString(),
      ),
    );

    if (result != null && result is FilterData) {
      setState(() {
        result.estateId = widget.estateId;
        filterData = result;
      });

      getFiles();
    }
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

  void sendCommentOrRate(int estateId) {
    String comment = commentController.value.text;

    bool rateIsValid = (rate ?? 0) > 0;
    bool commentIsValid = comment.isNotEmpty;

    if (commentIsValid && rateIsValid) {
      sendCommentRateBloc.add(EstateProfileCommentRateSendCommentAndRateEvent(estateId, rate!, comment));
    }

    if (commentIsValid && !rateIsValid) {
      sendCommentRateBloc.add(EstateProfileCommentRateSendCommentEvent(estateId, comment));
    }

    if (!commentIsValid && rateIsValid) {
      sendCommentRateBloc.add(EstateProfileCommentRateSendRateEvent(estateId, rate!));
    }
    focusNode.unfocus();
    rate = null;
  }

  void retry(BuildContext context) {
    bloc.add(EstateProfileRequestEvent(widget.estateId));
  }

  void report() {
    callToSupport();
  }
}
