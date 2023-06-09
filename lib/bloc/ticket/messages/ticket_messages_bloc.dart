import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/ticket_details.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';

part 'ticket_messages_event.dart';

part 'ticket_messages_state.dart';

class TicketMessagesBloc extends Bloc<TicketMessagesEvent, TicketMessagesState> {
  TicketMessagesBloc() : super(TicketMessagesInitial()) {
    on<TicketMessagesRequestEvent>(_request);
  }

  FutureOr<void> _request(TicketMessagesRequestEvent event, Emitter<TicketMessagesState> emit) async {
    emit(TicketMessagesLoading());

    var headers = {
      "Authorization": await User.getBearerToken(),
    };

    var uri = Uri.parse("https://ticket.siraf.app/api/ticket/ticket?ticketId=${event.id}");

    var response = await http2.get(uri, headers: headers);

    if (!isResponseOk(response)) {
      return emit(TicketMessagesError(response: response));
    }

    return emit(TicketMessagesSuccess(response: response));
  }
}
