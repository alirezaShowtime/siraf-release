part of 'consultant_profile_bloc.dart';

@immutable
abstract class ConsultantProfileEvent {}

class ConsultantProfileLoad extends ConsultantProfileEvent {
  final int consultantId;

  ConsultantProfileLoad(this.consultantId);
}

class ConsultantProfileSendComment extends ConsultantProfileEvent {
  final String massage;
  final int consultantId;

  ConsultantProfileSendComment({
    required this.massage,
    required this.consultantId,
  });
}

class ConsultantProfileSendRate extends ConsultantProfileEvent {
  final double rate;
  final int consultantId;

  ConsultantProfileSendRate({
    required this.rate,
    required this.consultantId,
  });
}
