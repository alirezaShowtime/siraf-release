import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/ticket.dart';
import 'package:siraf3/models/user.dart';

part 'ticket_list_event.dart';

part 'ticket_list_state.dart';

class TicketListBloc extends Bloc<TicketListEvent, TicketListState> {
  TicketListBloc() : super(TicketListInitial()) {
    on<TicketListRequestEvent>(_request);
  }

  FutureOr<void> _request(TicketListRequestEvent event, Emitter<TicketListState> emit) async {
    emit(TicketListLoading());

    var headers = {
      "Authorization": await User.getBearerToken(),
    };

    var response = await http2.get(Uri.parse("https://ticket.siraf.app/api/ticket/tickets"), headers: headers);

    if (!isResponseOk(response)) {
      return emit(TicketListError(response: response));
    }
    return emit(TicketListSuccess(response: response));
  }
}
