import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:siraf3/http2.dart';


class RequestsEvent {
  
}

class RequestState {}

class RequestInitState extends RequestState {

}

class RequestErrorState extends RequestState {
  Response response;

  RequestErrorState({required this.response});
}

class RequestLoadedState extends RequestState {
  
}

class RequestLoadingState extends RequestState {
  
}