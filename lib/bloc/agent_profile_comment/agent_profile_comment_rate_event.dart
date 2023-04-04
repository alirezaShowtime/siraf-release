part of 'agent_profile_comment_rate_bloc.dart';

@immutable
abstract class AgentProfileCommentRateEvent {}

class AgentProfileCommentRateSendCommentEvent extends AgentProfileCommentRateEvent {
  final String message;
  final int consultantId;

  AgentProfileCommentRateSendCommentEvent(this.consultantId, this.message);
}

class AgentProfileCommentRateSendRateEvent extends AgentProfileCommentRateEvent {
  final double rate;
  final int consultantId;

  AgentProfileCommentRateSendRateEvent(this.consultantId, this.rate);
}

class AgentProfileCommentRateSendCommentAndRateEvent extends AgentProfileCommentRateEvent {
  final String message;
  final double rate;
  final int consultantId;

  AgentProfileCommentRateSendCommentAndRateEvent(this.consultantId, this.rate, this.message);
}
