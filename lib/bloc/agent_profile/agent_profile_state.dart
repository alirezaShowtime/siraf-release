part of 'agent_profile_bloc.dart';

@immutable
abstract class AgentProfileState {}

class AgentProfileInitState extends AgentProfileState {}

class AgentProfileSuccessState extends AgentProfileState {
  final ConsultantInfo consultantInfo;

  AgentProfileSuccessState(this.consultantInfo);
}

class AgentProfileErrorState extends AgentProfileState {
  final Response response;

  String get message => jDecode(response.body)["message"] ?? "";

  AgentProfileErrorState(this.response);
}
