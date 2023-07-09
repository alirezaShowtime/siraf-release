part of 'agency_profile_bloc.dart';

@immutable
abstract class EstateProfileEvent {}

class EstateProfileLoadEvent extends EstateProfileEvent {
  final int estateId;

  EstateProfileLoadEvent(this.estateId);
}

class EstateProfileLoadingEvent extends EstateProfileEvent {
  final int estateId;

  EstateProfileLoadingEvent(this.estateId);
}