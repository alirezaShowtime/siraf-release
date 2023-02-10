import 'package:siraf3/screens/agent_profile/agent_profile_screen.dart';

extension EventListener on AgentProfileScreenState {
  void share() {
    //todo: implement event listener
  }

  void viewComments() {
    //todo: implement event listener
  }

  void openFileBox() {
    //todo: implement event listener
  }

  void like(Map<String, dynamic> comment) {
    //todo: implement event listener
  }

  void answer(Map<String, dynamic> comment) {
    //todo: implement event listener
  }

  void dislike(Map<String, dynamic> comment) {}

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

  void sendComment() {}
}
