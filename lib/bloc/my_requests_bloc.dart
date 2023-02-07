import 'package:http/http.dart';
import 'package:bloc/bloc.dart';

class MyRequestsEvent {}

class MyRequestsState {}

class MyREquestsInitState extends MyRequestsState {}

class MyRequestsLoadingState extends MyRequestsState {}

class MyRequestsLoadedState extends MyRequestsState {}

class MyRequestsErrorState extends MyRequestsState {
  Response? response;

  MyRequestsErrorState({this.response});
}

// class 