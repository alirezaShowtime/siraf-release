part of 'seen_message_bloc.dart';

@immutable
abstract class SeenMessageEvent {}

class SeenMessageRequestEvent extends SeenMessageEvent {
  int chatId;

  SeenMessageRequestEvent(this.chatId);
}
