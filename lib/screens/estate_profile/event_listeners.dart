part of 'package:siraf3/screens/estate_profile/estate_profile_screen.dart';

extension EventListener on _EstateProfileScreen {
  void share() {
    if (estateProfile == null) return;

    FlutterShare.share(
      title: 'اشتراک گذاری فایل',
      text: '',
      linkUrl: estateProfile!.shareLink,
      chooserTitle: 'اشتراک گذاری در',
    );
  }

  void viewComments() {
    //todo: implement event listener
  }

  void openFileBox() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(
          originalFilterData: FilterData(cityIds: cities.map<int>((e) => e.id!).toList()),
          filterData: filterData,
        ),
      ),
    );

    if (result != null && result is FilterData) {
      setState(() {
        result.estateId = widget.estateId;
        filterData = result;
      });

      print(filterData.toQueryString());

      getFiles();
    }
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

  void sendCommentOrRate(int estateId) {
    String comment = commentController.value.text;

    bool rateIsValid = (rate ?? 0) > 0;
    bool commentIsValid = comment.isNotEmpty;

    //if true, the comment and the rate will be sent
    if (commentIsValid && rateIsValid) {
      sendCommentRateBloc.add(EstateProfileCommentRateSendCommentAndRateEvent(estateId, rate!, comment));
    }

    //if true, only the comment will be sent
    if (commentIsValid && !rateIsValid) {
      sendCommentRateBloc.add(EstateProfileCommentRateSendCommentEvent(estateId, comment));
    }

    //if true, ony the rate will be sent
    if (!commentIsValid && rateIsValid) {
      sendCommentRateBloc.add(EstateProfileCommentRateSendRateEvent(estateId, rate!));
    }
  }

  void retry(BuildContext context) {
    BlocProvider.of<EstateProfileBloc>(context).add(EstateProfileLoadingEvent(widget.estateId));
  }

  void report() {
    callToSupport();
  }
}
