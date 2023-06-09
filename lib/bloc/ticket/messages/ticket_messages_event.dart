part of 'ticket_messages_bloc.dart';

@immutable
abstract class TicketMessagesEvent {}

class TicketMessagesRequestEvent extends TicketMessagesEvent {
  int id;

  TicketMessagesRequestEvent({required this.id});
}
