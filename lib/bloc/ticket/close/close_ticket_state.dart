part of 'close_ticket_bloc.dart';

@immutable
abstract class CloseTicketState {}

class CloseTicketInitial extends CloseTicketState {}

class CloseTicketLoading extends CloseTicketState {}

class CloseTicketError extends CloseTicketState {
  String? message;

  CloseTicketError(Response response) {
    message = jDecode(response.body)["message"];
  }
}

class CloseTicketSuccess extends CloseTicketState {}
