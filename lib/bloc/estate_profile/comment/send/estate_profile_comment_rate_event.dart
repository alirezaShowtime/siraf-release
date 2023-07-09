part of 'estate_profile_comment_rate_bloc.dart';

abstract class EstateProfileCommentRateEvent {}

class EstateProfileCommentRateSendCommentEvent extends EstateProfileCommentRateEvent {
  final String message;
  final int estateId;

  EstateProfileCommentRateSendCommentEvent(this.estateId, this.message);
}

class EstateProfileCommentRateSendRateEvent extends EstateProfileCommentRateEvent {
  final double rate;
  final int estateId;

  EstateProfileCommentRateSendRateEvent(this.estateId, this.rate);
}

class EstateProfileCommentRateSendCommentAndRateEvent extends EstateProfileCommentRateEvent {
  final String message;
  final double rate;
  final int estateId;

  EstateProfileCommentRateSendCommentAndRateEvent(this.estateId, this.rate, this.message);
}
