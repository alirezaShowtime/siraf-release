part of 'consultant_profile_comment_rate_bloc.dart';

@immutable
abstract class ConsultantProfileCommentRateState {}

class ConsultantProfileCommentRateInitial extends ConsultantProfileCommentRateState {}

class ConsultantProfileCommentRateSending extends ConsultantProfileCommentRateState {}

class ConsultantProfileCommentRateSuccess extends ConsultantProfileCommentRateState {
  Comment? comment;
  bool isReply;

  ConsultantProfileCommentRateSuccess(Response? res, this.isReply) {
    comment = res == null ? null : Comment.fromJson(jDecode(res.body)["data"]);
  }
}

class ConsultantProfileCommentRateError extends ConsultantProfileCommentRateState {
  String? message;

  ConsultantProfileCommentRateError(Response response) {
    message = jDecode(response.body)["message"];
  }
}
