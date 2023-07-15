part of 'estate_profile_bloc.dart';

@immutable
abstract class EstateProfileEvent {}

class EstateProfileRequestEvent extends EstateProfileEvent {
  final int estateId;

  EstateProfileRequestEvent(this.estateId);
}
