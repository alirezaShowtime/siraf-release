part of 'agency_profile_bloc.dart';

@immutable
abstract class AgencyProfileEvent {}

class AgencyProfileLoadEvent extends AgencyProfileEvent {
  final int estateId;

  AgencyProfileLoadEvent(this.estateId);
}

class AgencyProfileLoadingEvent extends AgencyProfileEvent {
  final int estateId;

  AgencyProfileLoadingEvent(this.estateId);
}