import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;

part 'chat_block_event.dart';

part 'chat_block_state.dart';

class ChatBlockBloc extends Bloc<ChatBlockEvent, ChatBlockState> {
  ChatBlockBloc() : super(ChatBlockInitial()) {
    on<ChatBlockRequestEvent>(_request);
  }

  FutureOr<void> _request(ChatBlockRequestEvent event, Emitter<ChatBlockState> emit) async {
    emit(ChatBlockLoading());

    var res = await http2.putJsonWithToken(
      Uri.parse("https://chat.siraf.app/api/chat/changeStatusChatUser/"),
      body: {
        "ids": event.ids,
        "disable": 1,
      },
    );

    if (!isResponseOk(res)) {
      return emit(ChatBlockError(res));
    }
    return emit(ChatBlockSuccess(event.block));
  }
}
