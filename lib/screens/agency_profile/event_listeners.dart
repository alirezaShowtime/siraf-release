part of 'package:siraf3/screens/agency_profile/agency_profile_screen.dart';

extension EventListener on _AgencyProfileScreen {
  void share() {
    //todo: implement event listener
  }

  void viewComments() {
    //todo: implement event listener
  }

  void openFileBox() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(
          originalFilterData: FilterData(
              cityIds: cities.map<int>((e) => e.id!).toList()),
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

  void like(Comment comment) {
    //todo: implement event listener
  }

  void answer(Comment comment) {
    //todo: implement event listener
  }

  void dislike(Comment comment) {}

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

  void sendCommentOrRate(int estateId) {
    String comment = commentController.value.text;

    bool rateIsValid = (rate ?? 0) > 0;
    bool commentIsValid = comment.isNotEmpty;

    //if true, the comment and the rate will be sent
    if (commentIsValid && rateIsValid) {
      commentRateBloc.add(AgencyProfileCommentRateSendCommentAndRateEvent(estateId, rate!, comment));
    }

    //if true, only the comment will be sent
    if (commentIsValid && !rateIsValid) {
      commentRateBloc.add(AgencyProfileCommentRateSendCommentEvent(estateId, comment));
    }

    //if true, ony the rate will be sent
    if (!commentIsValid && rateIsValid) {
      commentRateBloc.add(AgencyProfileCommentRateSendRateEvent(estateId, rate!));
    }
  }

  void retry(BuildContext context) {
    BlocProvider.of<AgencyProfileBloc>(context).add(AgencyProfileLoadingEvent(widget.estateId));
  }

  void report() {}
}
