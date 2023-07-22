part of 'chat_message_search_bloc.dart';

enum MessageSearchType { Next, Previous }

@immutable
abstract class ChatMessageSearchEvent {}

class ChatMessageSearchCancelEvent extends ChatMessageSearchEvent {}

class ChatMessageSearchRequestEvent extends ChatMessageSearchEvent {
  int chatId;
  String? q;
  MessageSearchType? type;
  int? lastId;

  ChatMessageSearchRequestEvent({required this.chatId, this.q, this.lastId, this.type});
}
