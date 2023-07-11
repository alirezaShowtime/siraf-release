part of 'consultant_profile_bloc.dart';

@immutable
abstract class ConsultantProfileEvent {}

class ConsultantProfileRequestEvent extends ConsultantProfileEvent {
  final int consultantId;

  ConsultantProfileRequestEvent(this.consultantId);
}
