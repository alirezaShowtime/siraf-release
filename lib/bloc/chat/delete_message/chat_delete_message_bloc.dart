import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;

part 'chat_delete_message_event.dart';

part 'chat_delete_message_state.dart';

class ChatDeleteMessageBloc extends Bloc<ChatDeleteMessageEvent, ChatDeleteMessageState> {
  ChatDeleteMessageBloc() : super(ChatDeleteMessageInitial()) {
    on<ChatDeleteMessageRequestEvent>(_request);
    on<ChatDeleteMessageSendingEvent>((event, emit) => emit(ChatDeleteMessageSending(event.widgetKey)));
  }

  FutureOr<void> _request(ChatDeleteMessageRequestEvent event, Emitter<ChatDeleteMessageState> emit) async {
    emit(ChatDeleteMessageLoading());

    var res = await http2.putJsonWithToken(
      Uri.parse("https://chat.siraf.app/api/message/removeMessageUser/"),
      body: {
        "delete": !event.isForAll ? "forme" : "everyone",
        "ids": event.ids,
        "chatId": event.chatId,
      },
    );

    if (!isResponseOk(res)) {
      return emit(ChatDeleteMessageError(res));
    }

    return emit(ChatDeleteMessageSuccess());
  }
}
