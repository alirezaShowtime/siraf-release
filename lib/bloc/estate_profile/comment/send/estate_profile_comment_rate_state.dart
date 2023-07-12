part of 'estate_profile_comment_rate_bloc.dart';

@immutable
abstract class EstateProfileCommentRateState {}

class EstateProfileCommentRateInitial extends EstateProfileCommentRateState {}

class EstateProfileCommentRateSending extends EstateProfileCommentRateState {}

class EstateProfileCommentRateSuccess extends EstateProfileCommentRateState {
  late Comment comment;
  bool isReply;

  EstateProfileCommentRateSuccess(Response res, this.isReply) {
    comment = Comment.fromJson(jDecode(res.body)["data"]);
  }
}

class EstateProfileCommentRateError extends EstateProfileCommentRateState {
  String? message;

  EstateProfileCommentRateError(Response response) {
    message = jDecode(response.body)["message"];
  }
}
