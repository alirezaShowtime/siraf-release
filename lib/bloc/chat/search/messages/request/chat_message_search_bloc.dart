import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/chat_message.dart';

part 'chat_message_search_event.dart';
part 'chat_message_search_state.dart';

class ChatMessageSearchBloc extends Bloc<ChatMessageSearchEvent, ChatMessageSearchState> {
  String? q;
  bool cancelRequest = false;

  ChatMessageSearchBloc() : super(ChatMessageSearchInitial()) {
    on<ChatMessageSearchRequestEvent>(_request);
    on<ChatMessageSearchCancelEvent>((event, emit) {
      cancelRequest = true;
      emit(ChatMessageSearchCancel());
    });
  }

  FutureOr<void> _request(ChatMessageSearchRequestEvent event, Emitter<ChatMessageSearchState> emit) async {
    if (state is ChatMessageSearchLoading) return;
    emit(ChatMessageSearchLoading());

    if (event.q != null) {
      q = event.q;
    }

    var uri = Uri.parse("https://chat.siraf.app/api/message/messageSearchUser/");

    uri = uri.replace(
      queryParameters: {
        "chatId": event.chatId.toString(),
        "q": q,
        if (event.lastId != null) "lastId": event.lastId.toString(),
        if (MessageSearchType.values.contains(event.type)) "type": event.type == MessageSearchType.Next ? "next" : "previous",
      },
    );

    var res = await http2.getWithToken(uri);

    if (!isResponseOk(res)) {
      return emit(ChatMessageSearchError(res));
    }

    if (!cancelRequest) {
      return emit(ChatMessageSearchSuccess(res, searched: q ?? "", type: event.type));
    }else{
      cancelRequest = false;
    }
  }
}
