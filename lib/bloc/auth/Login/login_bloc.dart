import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginRequestEvent>(_request);
  }

  FutureOr<void> _request(LoginRequestEvent event, Emitter<LoginState> emit) async {
    if (state is LoginLoading) return;
    emit(LoginLoading());

    Uri uri = Uri.parse("https://auth.siraf.app/api/user/login/");

    var body = jsonEncode({'mobile': event.numberPhone, 'type': 1});

    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    var res = await http2.post(uri, body: body, headers: headers);

    if (!isResponseOk(res)) {
      return emit(LoginError(response: res));
    }

// todo remote below line
    notify(jDecode(res.body)['data'].toString(), duration: Duration(milliseconds: 5000));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobile', event.numberPhone);

    return emit(LoginSuccess(numberPhone: event.numberPhone));
  }
}
