part of 'close_ticket_bloc.dart';

@immutable
abstract class CloseTicketEvent {}

class CloseTicketRequestEvent extends CloseTicketEvent {
  List<int> ids;

  CloseTicketRequestEvent(this.ids);
}
