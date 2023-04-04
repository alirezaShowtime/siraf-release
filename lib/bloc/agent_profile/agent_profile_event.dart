part of 'agent_profile_bloc.dart';

@immutable
abstract class AgentProfileEvent {}

class AgentProfileLoad extends AgentProfileEvent {
  final int consultantId;

  AgentProfileLoad(this.consultantId);
}

class AgentProfileSendComment extends AgentProfileEvent {
  final String massage;
  final int consultantId;

  AgentProfileSendComment({
    required this.massage,
    required this.consultantId,
  });
}

class AgentProfileSendRate extends AgentProfileEvent {
  final double rate;
  final int consultantId;

  AgentProfileSendRate({
    required this.rate,
    required this.consultantId,
  });
}
