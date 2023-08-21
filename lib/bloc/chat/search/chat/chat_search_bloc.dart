import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/chat_item.dart';

part 'chat_search_event.dart';
part 'chat_search_state.dart';

class ChatSearchBloc extends Bloc<ChatSearchEvent, ChatSearchState> {
  bool canceledRequest = false;

  ChatSearchBloc() : super(ChatSearchInitial()) {
    on<ChatSearchRequestEvent>(_request);
    on<ChatSearchCancelEvent>((event, emit) {
      canceledRequest = true;
      emit(ChatSearchCancel());
    });
  }

  FutureOr<void> _request(ChatSearchRequestEvent event, Emitter<ChatSearchState> emit) async {
    emit(ChatSearchLoading());

    var res = await http2.getWithToken(Uri.parse("https://chat.siraf.app/api/chat/chatsUser/?q=${event.q}"));

    if (!isResponseOk(res)) {
      return emit(ChatSearchError(res));
    }

    if (!canceledRequest) {
      return emit(ChatSearchSuccess(res));
    } else {
      canceledRequest = false;
    }
  }
}
