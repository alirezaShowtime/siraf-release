part of 'chat_delete_message_bloc.dart';

@immutable
abstract class ChatDeleteMessageEvent {}

class ChatDeleteMessageSendingEvent extends ChatDeleteMessageEvent {
  Key widgetKey;

  ChatDeleteMessageSendingEvent(this.widgetKey);
}

class ChatDeleteMessageRequestEvent extends ChatDeleteMessageEvent {
  List<int> ids;
  bool isForAll;
  int chatId;

  ChatDeleteMessageRequestEvent({required this.ids, required this.isForAll, required this.chatId});
}
