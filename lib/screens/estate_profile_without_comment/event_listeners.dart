part of 'estate_profile_screen.dart';

extension EventListener on _EstateProfileScreen {
  void share() {
    if (estateProfile?.shareLink == null) return;

    push(
      context,
      EstateShareScreen(
        shareLink: estateProfile!.shareLink!,
        estateName: estateProfile!.name!,
        managerName: estateProfile!.managerName!,
        estateLogo: estateProfile!.logoFile,
      ),
    );
  }

  void openFileBox() async {
    var result = await push(
      context,
      FilterScreen(
        originalFilterData: FilterData(cityIds: cities.map<int>((e) => e.id!).toList()),
        filterData: filterData,
        total_url: getFileUrl('file/filesEstate/').toString(),
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

      if (moreDetail && showComment) {
        try {
          previousScrollPositionComment = commentsListViewController.position.pixels;
        } catch (e) {
          previousScrollPositionComment = 0.0;
        }
        scrollTo(commentsListViewController, 0.0);
      }
      if (!moreDetail && showComment) {
        scrollTo(commentsListViewController, previousScrollPositionComment);
      }

      if (moreDetail && !showComment) {
        try {
          previousScrollPositionFiles = filesListViewController.position.pixels;
        } catch (e) {
          previousScrollPositionFiles = 0.0;
        }
        scrollTo(filesListViewController, 0.0);
      }
      if (!moreDetail && showComment) {
        scrollTo(filesListViewController, previousScrollPositionFiles);
      }
    });
  }

  void sendCommentOrRate(int estateId) {
    String comment = commentController.value.text;

    bool rateIsValid = (rate ?? 0) > 0;
    /* bool commentIsValid = comment.isNotEmpty;

    if (commentIsValid && rateIsValid) {
      sendCommentRateBloc.add(EstateProfileCommentRateSendCommentAndRateEvent(estateId, rate!, comment));
    } else if (commentIsValid && !rateIsValid) {
      sendCommentRateBloc.add(EstateProfileCommentRateSendCommentEvent(estateId, comment));
    } else 
    if (!commentIsValid && rateIsValid) {

    */
    if (rateIsValid) {
      sendCommentRateBloc.add(EstateProfileCommentRateSendRateEvent(estateId, rate!));
    } else {
      notify("امتیاز یا نظری وارد نکرده اید.");
    }
    focusNode.unfocus();
  }

  void retry(BuildContext context) {
    bloc.add(EstateProfileRequestEvent(widget.estateId));
  }

  void report() {
    callToSupport();
  }
}
