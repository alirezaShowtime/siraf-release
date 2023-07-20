part of 'chat_message_search_bloc.dart';

@immutable
abstract class ChatMessageSearchEvent {}

class ChatMessageSearchCancelEvent extends ChatMessageSearchEvent {}

class ChatMessageSearchRequestEvent extends ChatMessageSearchEvent {
  int chatId;
  String q;

  ChatMessageSearchRequestEvent({required this.chatId, required this.q});
}
