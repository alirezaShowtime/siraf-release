part of 'ticket_messages_bloc.dart';

@immutable
abstract class TicketMessagesState {}

class TicketMessagesInitial extends TicketMessagesState {}

class TicketMessagesLoading extends TicketMessagesState {}

class TicketMessagesSuccess extends TicketMessagesState {
  late TicketDetails ticketDetails;

  Response response;

  TicketMessagesSuccess({required this.response}) {
    var data = jDecode(response.body)["data"];

    ticketDetails = _removeEmptyMessage(TicketDetails.fromJson(data));
  }

  TicketDetails _removeEmptyMessage(TicketDetails ticketDetails) {
    List<Message> newList = [];

    for (Message message in ticketDetails.messages!) {
      if (!message.message.isFill() && !message.fileMessage.isFill()) continue;
      newList.add(message);
    }

    ticketDetails.messages = newList;

    return ticketDetails;
  }
}

class TicketMessagesError extends TicketMessagesState {
  Response response;

  String? message;

  TicketMessagesError({required this.response}) {
    message = jDecode(response.body)['message'] as String?;
  }
}
