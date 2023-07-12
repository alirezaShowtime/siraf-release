part of 'consultant_profile_comment_rate_bloc.dart';

@immutable
abstract class ConsultantProfileCommentRateState {}

class ConsultantProfileCommentRateInitial extends ConsultantProfileCommentRateState {}

class ConsultantProfileCommentRateSending extends ConsultantProfileCommentRateState {}

class ConsultantProfileCommentRateSuccess extends ConsultantProfileCommentRateState {
  late Comment comment;
  bool isReply;

  ConsultantProfileCommentRateSuccess(Response res, this.isReply) {
    comment = Comment.fromJson(jDecode(res.body)["data"]);
  }
}

class ConsultantProfileCommentRateError extends ConsultantProfileCommentRateState {
  String? message;

  ConsultantProfileCommentRateError(Response response) {
    message = jDecode(response.body)["message"];
  }
}
