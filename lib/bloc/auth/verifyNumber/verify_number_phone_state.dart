part of 'verify_number_phone_bloc.dart';

@immutable
abstract class VerifyNumberPhoneState {}

class VerifyNumberPhoneInitial extends VerifyNumberPhoneState {}

class VerifyNumberPhoneLoading extends VerifyNumberPhoneState {}

class VerifyNumberPhoneError extends VerifyNumberPhoneState {
  String? message;

  VerifyNumberPhoneError({Response? response}) {
    if (response == null) return;

    message = jDecode(response.body)["message"];
  }
}

class VerifyNumberPhoneSuccess extends VerifyNumberPhoneState {
  User user;

  VerifyNumberPhoneSuccess(this.user);
}
