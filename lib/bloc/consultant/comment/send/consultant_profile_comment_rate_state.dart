part of 'consultant_profile_comment_rate_bloc.dart';

@immutable
abstract class ConsultantProfileCommentRateState {}

class ConsultantProfileCommentRateInitial extends ConsultantProfileCommentRateState {}

class ConsultantProfileCommentRateSending extends ConsultantProfileCommentRateState {}

class ConsultantProfileCommentRateSuccess extends ConsultantProfileCommentRateState {
  final Comment? comment;

  ConsultantProfileCommentRateSuccess({this.comment});
}

class ConsultantProfileCommentRateError extends ConsultantProfileCommentRateState {}
