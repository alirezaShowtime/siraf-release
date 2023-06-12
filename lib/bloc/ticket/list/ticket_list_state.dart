part of 'ticket_list_bloc.dart';

@immutable
abstract class TicketListState {}

class TicketListInitial extends TicketListState {}

class TicketListLoading extends TicketListState {}

class TicketListSuccess extends TicketListState {
  late List<Ticket> tickets;

  Response response;

  TicketListSuccess({required this.response}) {
    tickets = Ticket.fromList(jDecode(response.body)["data"]);
  }
}

class TicketListError extends TicketListState {
  Response response;

  String? message;

  TicketListError({required this.response}) {
    message = jDecode(response.body)["message"];
  }
}
