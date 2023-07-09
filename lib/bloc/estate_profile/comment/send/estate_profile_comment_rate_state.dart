part of 'estate_profile_comment_rate_bloc.dart';

@immutable
abstract class EstateProfileCommentRateState {}

class EstateProfileCommentRateInitial extends EstateProfileCommentRateState {}

class EstateProfileCommentRateSending extends EstateProfileCommentRateState {}

class EstateProfileCommentRateSuccess extends EstateProfileCommentRateState {
  final Comment? comment;

  EstateProfileCommentRateSuccess({this.comment});
}

class EstateProfileCommentRateError extends EstateProfileCommentRateState {}
