part of 'consultant_profile_comment_rate_bloc.dart';

@immutable
abstract class ConsultantProfileCommentRateEvent {}

class ConsultantProfileCommentRateSendCommentEvent extends ConsultantProfileCommentRateEvent {
  final String message;
  final int consultantId;
  int? replyId;

  ConsultantProfileCommentRateSendCommentEvent(this.consultantId, this.message, {this.replyId});
}

class ConsultantProfileCommentRateSendRateEvent extends ConsultantProfileCommentRateEvent {
  final double rate;
  final int consultantId;

  ConsultantProfileCommentRateSendRateEvent(this.consultantId, this.rate);
}

class ConsultantProfileCommentRateSendCommentAndRateEvent extends ConsultantProfileCommentRateEvent {
  final String message;
  final double rate;
  final int consultantId;

  ConsultantProfileCommentRateSendCommentAndRateEvent(this.consultantId, this.rate, this.message);
}
