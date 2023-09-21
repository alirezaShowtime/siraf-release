import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/request.dart' as request;

class RequestsEvent {
  String? sort;
  bool? hasFilter;

  RequestsEvent({this.sort, this.hasFilter});
}

class RequestsState {}

class RequestsInitState extends RequestsState {}

class RequestsErrorState extends RequestsState {
  Response response;

  RequestsErrorState({required this.response});
}

class RequestsLoadedState extends RequestsState {
  List<request.Request> requests;

  RequestsLoadedState({required this.requests});
}

class RequestsLoadingState extends RequestsState {}

class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  RequestsBloc() : super(RequestsInitState()) {
    on(_onEvent);
  }

  _onEvent(RequestsEvent event, Emitter<RequestsState> emit) async {
    emit(RequestsLoadingState());

    var sorting_key = (event.hasFilter ?? false) ? "filter" : "sort";

    var response = await http2.getWithToken(getEstateUrl("requestFile/myRequestFiles/" + (event.sort != null ? "?$sorting_key=${event.sort}" : "")));

    if (isResponseOk(response)) {
      emit(
        RequestsLoadedState(
          requests: request.Request.fromList(jDecode(response.body)['data']),
        ),
      );
    } else {
      emit(RequestsErrorState(response: response));
    }
  }
}
