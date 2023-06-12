part of 'verify_number_phone_bloc.dart';

@immutable
abstract class VerifyNumberPhoneEvent {}

class VerifyNumberPhoneRequestEvent extends VerifyNumberPhoneEvent {
  String code;
  String numberPhone;

  VerifyNumberPhoneRequestEvent({required this.code, required this.numberPhone});
}
