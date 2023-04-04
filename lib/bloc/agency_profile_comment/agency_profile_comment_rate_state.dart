part of 'agency_profile_comment_rate_bloc.dart';

@immutable
abstract class AgencyProfileCommentRateState {}

class AgencyProfileCommentRateInitialState extends AgencyProfileCommentRateState {}

class AgencyProfileCommentRateSendingState extends AgencyProfileCommentRateState {}

class AgencyProfileCommentRateSuccessState extends AgencyProfileCommentRateState {
  final Comment? comment;

  AgencyProfileCommentRateSuccessState({this.comment});
}

class AgencyProfileCommentRateErrorState extends AgencyProfileCommentRateState {}
