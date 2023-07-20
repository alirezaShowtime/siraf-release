import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/chat_message.dart';

part 'chat_message_search_event.dart';

part 'chat_message_search_state.dart';

class ChatMessageSearchBloc extends Bloc<ChatMessageSearchEvent, ChatMessageSearchState> {
  ChatMessageSearchBloc() : super(ChatMessageSearchInitial()) {
    on<ChatMessageSearchRequestEvent>(_request);
    on<ChatMessageSearchCancelEvent>((event, emit) => emit(ChatMessageSearchCancel()));
  }

  FutureOr<void> _request(ChatMessageSearchRequestEvent event, Emitter<ChatMessageSearchState> emit) async {
    if (state is ChatMessageSearchLoading) return;
    emit(ChatMessageSearchLoading());

    var res = await http2.getWithToken(Uri.parse("https://chat.siraf.app/api/message/messageSearchUser/?chatId=${event.chatId}&q=${event.q}"));

    if (!isResponseOk(res)) {
      return emit(ChatMessageSearchError(res));
    }

    return emit(ChatMessageSearchSuccess(res, searched: event.q));
  }
}
