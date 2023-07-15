import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;

part 'chat_delete_event.dart';

part 'chat_delete_state.dart';

class ChatDeleteBloc extends Bloc<ChatDeleteEvent, ChatDeleteState> {
  ChatDeleteBloc() : super(ChatDeleteInitial()) {
    on<ChatDeleteRequestEvent>(_request);
  }

  FutureOr<void> _request(ChatDeleteRequestEvent event, Emitter<ChatDeleteState> emit) async {
    emit(ChatDeleteLoading());

    var res = await http2.putJsonWithToken(
      Uri.parse("https://chat.siraf.app/api/chat/changeStatusChatUser/"),
      body: {
        "ids": event.ids,
        "delete": 1,
      },
    );

    if (!isResponseOk(res)) {
      return emit(ChatDeleteError(res));
    }
    return emit(ChatDeleteSuccess(event.delete));
  }
}
