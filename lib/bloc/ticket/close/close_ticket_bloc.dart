import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:siraf3/bloc/request_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:http/http.dart';
import 'package:meta/meta.dart';

part 'close_ticket_event.dart';

part 'close_ticket_state.dart';

class CloseTicketBloc extends RequestBloc<CloseTicketEvent, CloseTicketState> {
  CloseTicketBloc() : super(CloseTicketInitial()) {
    on<CloseTicketRequestEvent>(_request);
  }

  FutureOr<void> _request(CloseTicketRequestEvent event, Emitter<CloseTicketState> emit) async {
    emit(CloseTicketLoading());

    var ids = event.ids.join(',');
    //todo: maybe incorrect link
    var res = await http2.getWithToken(Uri.parse("https://ticket.siraf.app/api/ticket/ticketClose/?ticketIds=[$ids]"));

    if (!isResponseOk(res)) {
      return emit(CloseTicketError(res));
    }

    return emit(CloseTicketSuccess());
  }
}
