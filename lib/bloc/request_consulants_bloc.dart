import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/request_consultant.dart';

class RequestConsultantEvent {
  int id;

  RequestConsultantEvent({required this.id});
}

class RequestConsultantLoadEvent extends RequestConsultantEvent {
  RequestConsultantLoadEvent({required super.id});
}

class RequestConsultantState {}

class RequestConsultantInitState extends RequestConsultantState {}

class RequestConsultantLoadingState extends RequestConsultantState {}

class RequestConsultantLoadedState extends RequestConsultantState {
  List<RequestConsultant> consultants;

  RequestConsultantLoadedState({required this.consultants});
}

class RequestConsultantErrorState extends RequestConsultantState {
  Response? response;

  RequestConsultantErrorState({required this.response});
}

class RequestConsultantBloc
    extends Bloc<RequestConsultantEvent, RequestConsultantState> {
  RequestConsultantBloc() : super(RequestConsultantInitState()) {
    on(_onEvent);
  }

  _onEvent(RequestConsultantEvent event, emit) async {
    emit(RequestConsultantLoadingState());

    var response = await http2.getWithToken(
        getEstateUrl("requestFile/consultantRequestFile/?id=${event.id}"));

    if (isResponseOk(response)) {
      var consultants = <RequestConsultant>[];

      if (response.body.isNotEmpty) {
        consultants = jDecode(response.body)['data'] == ""
            ? []
            : RequestConsultant.fromList(jDecode(response.body)['data']);
      }

      emit(RequestConsultantLoadedState(consultants: consultants));
    } else {
      emit(RequestConsultantErrorState(response: response));
    }
  }
}
