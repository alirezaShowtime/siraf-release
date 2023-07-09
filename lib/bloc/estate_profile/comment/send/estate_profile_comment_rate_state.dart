part of 'estate_profile_comment_rate_bloc.dart';

@immutable
abstract class EstateProfileCommentRateState {}

class EstateProfileCommentRateInitialState extends EstateProfileCommentRateState {}

class EstateProfileCommentRateSendingState extends EstateProfileCommentRateState {}

class EstateProfileCommentRateSuccessState extends EstateProfileCommentRateState {
  final Comment? comment;

  EstateProfileCommentRateSuccessState({this.comment});
}

class EstateProfileCommentRateErrorState extends EstateProfileCommentRateState {}
