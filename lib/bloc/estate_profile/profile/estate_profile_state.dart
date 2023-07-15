part of 'estate_profile_bloc.dart';

@immutable
abstract class EstateProfileState {}

class EstateProfileInitial extends EstateProfileState {}

class EstateProfileLoading extends EstateProfileState {}

class EstateProfileSuccessState extends EstateProfileState {
  final EstateProfile estateProfile;

  EstateProfileSuccessState(this.estateProfile);
}

class EstateProfileErrorState extends EstateProfileState {
  String? message;

  EstateProfileErrorState(Response response) {
    message = jDecode(response.body)["message"];
  }
}
