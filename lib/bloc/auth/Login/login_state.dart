part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginError extends LoginState {
  String? message;

  LoginError({Response? response}) {
    if (response != null) {
      message = jDecode(response.body)["message"];
    }
  }
}

class LoginSuccess extends LoginState {
  String numberPhone;

  LoginSuccess({required this.numberPhone});
}
