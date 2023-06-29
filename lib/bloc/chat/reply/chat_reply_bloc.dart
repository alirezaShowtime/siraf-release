import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/models/chat_message.dart';

class ChatReplyEvent {


ChatMessage? chatMessage;

ChatReplyEvent(this.chatMessage);

}

class ChatReplyBloc extends Bloc<ChatReplyEvent, ChatMessage?> {
  ChatReplyBloc() : super(null) {
    on<ChatReplyEvent>((event, emit) => emit(event.chatMessage));
  }
}
