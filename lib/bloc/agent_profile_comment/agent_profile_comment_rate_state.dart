part of 'agent_profile_comment_rate_bloc.dart';

@immutable
abstract class AgentProfileCommentRateState {}

class AgentProfileCommentRateInitialState extends AgentProfileCommentRateState {}

class AgentProfileCommentRateSendingState extends AgentProfileCommentRateState {}

class AgentProfileCommentRateSuccessState extends AgentProfileCommentRateState {
  final Comment? comment;

  AgentProfileCommentRateSuccessState({this.comment});
}

class AgentProfileCommentRateErrorState extends AgentProfileCommentRateState {}
