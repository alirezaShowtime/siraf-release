import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;

part 'seen_message_event.dart';

part 'seen_message_state.dart';

class SeenMessageBloc extends Bloc<SeenMessageEvent, SeenMessageState> {
  SeenMessageBloc() : super(SeenMessageInitial()) {
    on<SeenMessageRequestEvent>(_request);
  }

  FutureOr<void> _request(SeenMessageRequestEvent event, Emitter<SeenMessageState> emit) async {
    var res = await http2.putWithToken(Uri.parse("https://chat.siraf.app/api/messageSeenUser/?chatId=${event.chatId}"));

    if (!isResponseOk(res)) {
      return emit(SeenMessageError());
    }

    return emit(SeenMessageSuccess());
  }
}
