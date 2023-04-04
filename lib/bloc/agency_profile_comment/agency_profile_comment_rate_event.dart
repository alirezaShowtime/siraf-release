part of 'agency_profile_comment_rate_bloc.dart';

@immutable
abstract class AgencyProfileCommentRateEvent {}

class AgencyProfileCommentRateSendCommentEvent extends AgencyProfileCommentRateEvent {
  final String message;
  final int estateId;

  AgencyProfileCommentRateSendCommentEvent(this.estateId, this.message);
}

class AgencyProfileCommentRateSendRateEvent extends AgencyProfileCommentRateEvent {
  final double rate;
  final int estateId;

  AgencyProfileCommentRateSendRateEvent(this.estateId, this.rate);
}

class AgencyProfileCommentRateSendCommentAndRateEvent extends AgencyProfileCommentRateEvent {
  final String message;
  final double rate;
  final int estateId;

  AgencyProfileCommentRateSendCommentAndRateEvent(this.estateId, this.rate, this.message);
}
