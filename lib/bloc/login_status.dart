import 'package:bloc/bloc.dart';

class LoginStatus extends Bloc<bool, bool> {
  LoginStatus() : super(false) {
    on((event, emit) => emit(event as bool));
  }
}
