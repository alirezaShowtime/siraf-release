import 'package:http/http.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/ticket.dart';

class TicketsEvent {}

class TicketsState {}

class TicketsInitState extends TicketsState {}

class TicketsLoadingState extends TicketsState {}

class TicketsLoadedState extends TicketsState {
  List<Ticket> tickets;

  TicketsLoadedState({required this.tickets});
}

class TicketsErrorState extends TicketsState {
  Response response;

  TicketsErrorState({required this.response});
}

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  TicketsBloc(): super(TicketsInitState()) {
    on(_onEvent);
  }

  _onEvent(TicketsEvent event, Emitter<TicketsState> emit) async {
    emit(TicketsLoadingState());

    var response = await http2.getWithToken(getTicketUrl("ticket/tickets/"));

    if (isResponseOk(response)) {
      var json = jDecode(response.body);

      emit(TicketsLoadedState(tickets: Ticket.fromList(json['data'])));
    } else {
      emit(TicketsErrorState(response: response));
    }
  }
}
