part of 'chat_search_bloc.dart';

@immutable
abstract class ChatSearchEvent {}

class ChatSearchCancelEvent extends ChatSearchEvent {}

class ChatSearchRequestEvent extends ChatSearchEvent {
  String q;

  ChatSearchRequestEvent(this.q);
}
