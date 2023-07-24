import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/chat_item.dart';

part 'chat_search_event.dart';

part 'chat_search_state.dart';

class ChatSearchBloc extends Bloc<ChatSearchEvent, ChatSearchState> {
  bool cancelRequest = false;

  ChatSearchBloc() : super(ChatSearchInitial()) {
    on<ChatSearchRequestEvent>(_request);
    on<ChatSearchCancelEvent>((event, emit) {
      cancelRequest = true;
      emit(ChatSearchCancel());
    });
  }

  FutureOr<void> _request(ChatSearchRequestEvent event, Emitter<ChatSearchState> emit) async {
    emit(ChatSearchLoading());

    //todo: searching on chat list is not done
    // var res = await http2.get(Uri.parse(""));
    //
    // if (!isResponseOk(res)) {
    //   return emit(ChatSearchError(res));
    // }
    //
    // if (!cancelRequest) {
    //   cancelRequest = false;
    //   return emit(ChatSearchSuccess(res));
    // }
  }
}
