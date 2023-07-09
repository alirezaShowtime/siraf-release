part of 'consultant_profile_comment_rate_bloc.dart';

@immutable
abstract class ConsultantProfileCommentRateState {}

class ConsultantProfileCommentRateInitialState extends ConsultantProfileCommentRateState {}

class ConsultantProfileCommentRateSendingState extends ConsultantProfileCommentRateState {}

class ConsultantProfileCommentRateSuccessState extends ConsultantProfileCommentRateState {
  final Comment? comment;

  ConsultantProfileCommentRateSuccessState({this.comment});
}

class ConsultantProfileCommentRateErrorState extends ConsultantProfileCommentRateState {}
