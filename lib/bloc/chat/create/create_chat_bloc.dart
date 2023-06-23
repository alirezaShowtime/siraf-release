import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;

part 'create_chat_event.dart';

part 'create_chat_state.dart';

class CreateChatBloc extends Bloc<CreateChatEvent, CreateChatState> {
  CreateChatBloc() : super(CreateChatInitial()) {
    on<CreateChatRequestEvent>(_request);
  }

  FutureOr<void> _request(CreateChatRequestEvent event, Emitter<CreateChatState> emit) async {
    emit(CreateChatLoading());

    var res = await http2.postJsonWithToken(
      Uri.parse("https://chat.siraf.app/api/chat/addChatUser/"),
      body: {
        "fileConsultantId": event.fileConsultantId,
      },
    );

    if (!isResponseOk(res)) {
      return emit(CreateChatError());
    }

    return emit(CreateChatSuccess());
  }
}
