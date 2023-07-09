import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/chat_message.dart';

part 'messages_event.dart';

part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc() : super(MessagesInitial()) {
    on<MessagesRequestEvent>(_request);
  }

  FutureOr<void> _request(MessagesRequestEvent event, Emitter<MessagesState> emit) async {
    emit(MessagesLoading());

    var uri = Uri.parse("https://chat.siraf.app/api/message/messagesUser/?chatId=${event.id}");

    var response = await http2.getWithToken(uri);

    if (!isResponseOk(response)) {
      return emit(MessagesError(response: response));
    }

    return emit(MessagesSuccess(response: response));
  }
}
