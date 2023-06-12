import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/user.dart';

part 'verify_number_phone_event.dart';

part 'verify_number_phone_state.dart';

class VerifyNumberPhoneBloc extends Bloc<VerifyNumberPhoneEvent, VerifyNumberPhoneState> {
  VerifyNumberPhoneBloc() : super(VerifyNumberPhoneInitial()) {
    on<VerifyNumberPhoneRequestEvent>(_request);
  }

  FutureOr<void> _request(VerifyNumberPhoneRequestEvent event, Emitter<VerifyNumberPhoneState> emit) async {
    if (state is VerifyNumberPhoneLoading) return;
    emit(VerifyNumberPhoneLoading());

    var uri = Uri.parse("https://auth.siraf.app/api/user/confirm/");

    var body = {
      "code": event.code,
      "mobile": event.numberPhone,
    };

    var res = await http2.post(uri, body: body);

    if (!isResponseOk(res)) {
      return emit(VerifyNumberPhoneError(response: res));
    }

    var resBody = jDecode(res.body);

    var user = User.fromJson(resBody['data']['user']);

    user.token = resBody['data']['token']['access'];
    user.refreshToken = resBody['data']['token']['refresh'];

    await user.save();

    return emit(VerifyNumberPhoneSuccess(user));
  }
}
