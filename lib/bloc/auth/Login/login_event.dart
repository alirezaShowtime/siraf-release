part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginRequestEvent extends LoginEvent {
  String numberPhone;

  LoginRequestEvent(this.numberPhone);
}
