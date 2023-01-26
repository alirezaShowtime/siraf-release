import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/user.dart';

class AddViolationEvent {
  String title;
  String body;
  int fileId;

  AddViolationEvent(
      {required this.title, required this.body, required this.fileId});
}

class AddViolationState {}

class AddViolationInitState extends AddViolationState {}

class AddViolationLoadingState extends AddViolationState {}

class AddViolationErrorState extends AddViolationState {
  Response? response;

  AddViolationErrorState({this.response});
}

class AddViolationSuccessState extends AddViolationState {}

class AddViolationBloc extends Bloc<AddViolationEvent, AddViolationState> {
  AddViolationBloc() : super(AddViolationInitState()) {
    on(_onEvent);
  }

  FutureOr<void> _onEvent(
      AddViolationEvent event, Emitter<AddViolationState> emit) async {
    emit(AddViolationLoadingState());

    Response response;

    try {
      response = await post(getFileUrl("violation/addViolation/"),
          body: jsonEncode({
            "fileId": event.fileId,
            "title": event.title,
            "body": event.body,
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": await User.getBearerToken(),
          });

      print(response.statusCode);
      print(jDecode(response.body));
    } on HttpException catch (e) {
      emit(AddViolationErrorState());
      return;
    } on SocketException catch (e) {
      emit(AddViolationErrorState());
      return;
    }

    if (response.statusCode < 400) {
      emit(AddViolationSuccessState());
    } else {
      if (response.statusCode == 401) {
        User.remove();
      }
      emit(AddViolationErrorState(response: response));
    }
  }
}
