import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/chat_message.dart';

part 'chat_screen_pagination_event.dart';

part 'chat_screen_pagination_state.dart';

class ChatScreenPaginationBloc extends Bloc<ChatScreenPaginationEvent, ChatScreenPaginationState> {
  ChatScreenPaginationBloc() : super(ChatScreenPaginationInitial()) {
    on<ChatScreenPaginationRequestEvent>(_request);
  }

  FutureOr<void> _request(ChatScreenPaginationRequestEvent event, Emitter<ChatScreenPaginationState> emit) async {
    if (state is ChatScreenPaginationLoading) return;
    emit(ChatScreenPaginationLoading(event.type));

    var uri = Uri.parse("https://chat.siraf.app/api/message/messageByPage/");
    uri = uri.replace(
      queryParameters: {
        "chatId": event.chatId.toString(),
        "messageId": event.messageId.toString(),
        "type": event.type == ChatScreenPaginationType.Next ? "next" : "previous",
      },
    );

    var res = await http2.getWithToken(uri);

    if (!isResponseOk(res)) {
      return emit(ChatScreenPaginationError(res));
    }

    return emit(ChatScreenPaginationSuccess(res, type: event.type));
  }
}
