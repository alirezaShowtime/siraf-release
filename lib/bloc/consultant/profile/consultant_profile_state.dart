part of 'consultant_profile_bloc.dart';

@immutable
abstract class ConsultantProfileState {}

class ConsultantProfileInitState extends ConsultantProfileState {}

class ConsultantProfileSuccessState extends ConsultantProfileState {
  final ConsultantInfo consultantInfo;

  ConsultantProfileSuccessState(this.consultantInfo);
}

class ConsultantProfileErrorState extends ConsultantProfileState {
  final Response response;

  String get message => jDecode(response.body)["message"] ?? "";

  ConsultantProfileErrorState(this.response);
}
