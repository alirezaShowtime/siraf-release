part of 'agency_profile_bloc.dart';

@immutable
abstract class EstateProfileState {}

class EstateProfileInitial extends EstateProfileState {}

class EstateProfileSuccessState extends EstateProfileState {
  final EstateProfile estateProfile;

  EstateProfileSuccessState(this.estateProfile);
}

class EstateProfileErrorState extends EstateProfileState {
  String get message => jDecode(response.body)["message"] ?? "";
  final Response response;

  EstateProfileErrorState(this.response);
}