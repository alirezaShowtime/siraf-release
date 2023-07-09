part of 'estate_profile_bloc.dart';

@immutable
abstract class EstateProfileState {}

class EstateProfileInitial extends EstateProfileState {}

class EstateProfileSuccessState extends EstateProfileState {
  final EstateProfile estateProfile;

  EstateProfileSuccessState(this.estateProfile) {
    var comments = estateProfile.comment ?? [];

    for (Comment comment in comments) {
      var founds = comments.where((e) => e.id == comment.replyId).toList();
      comment.replies = founds;
      comments.removeWhere((e) => e.id == comment.replyId);
    }
  }
}

class EstateProfileErrorState extends EstateProfileState {
  String? message;

  EstateProfileErrorState(Response response) {
    message = jDecode(response.body)["message"];
  }
}
