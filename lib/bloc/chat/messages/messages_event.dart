part of 'messages_bloc.dart';

@immutable
abstract class MessagesEvent {}

class MessagesRequestEvent extends MessagesEvent {
  int id;

  MessagesRequestEvent({required this.id});
}
