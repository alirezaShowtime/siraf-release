part of 'agency_profile_bloc.dart';

@immutable
abstract class AgencyProfileState {}

class AgencyProfileInitial extends AgencyProfileState {}

class AgencyProfileSuccessState extends AgencyProfileState {
  final EstateProfile estateProfile;

  AgencyProfileSuccessState(this.estateProfile);
}

class AgencyProfileErrorState extends AgencyProfileState {
  String get message => jDecode(response.body)["message"] ?? "";
  final Response response;

  AgencyProfileErrorState(this.response);
}