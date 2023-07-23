part of 'chat_screen_pagination_bloc.dart';

enum ChatScreenPaginationType { Previous, Next }

@immutable
abstract class ChatScreenPaginationEvent {}

class ChatScreenPaginationRequestEvent extends ChatScreenPaginationEvent {
  ChatScreenPaginationType type;
  int chatId;
  int messageId;

  ChatScreenPaginationRequestEvent({
    required this.chatId,
    required this.messageId,
    required this.type,
  });
}
