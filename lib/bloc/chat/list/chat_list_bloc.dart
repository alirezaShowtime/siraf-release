import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/chat_item.dart';

part 'chat_list_event.dart';

part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc() : super(ChatListInitial()) {
    on<ChatListRequestEvent>(_request);
  }

  FutureOr<void> _request(ChatListRequestEvent event, Emitter<ChatListState> emit) async {
    emit(ChatListLoading());

    var res = await http2.getWithToken(Uri.parse("https://chat.siraf.app/api/chat/chatsUser"));

    if (!isResponseOk(res)) {
      return emit(ChatListError(response: res));
    }

    return emit(ChatListSuccess(res));
  }
}
