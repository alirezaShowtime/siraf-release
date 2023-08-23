import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;

class AddViolationEvent {
  String title;
  String body;
  int fileId;

  AddViolationEvent({required this.title, required this.body, required this.fileId});
}

class AddViolationState {}

class AddViolationInitState extends AddViolationState {}

class AddViolationLoadingState extends AddViolationState {}

class AddViolationErrorState extends AddViolationState {
  String? message;

  AddViolationErrorState(Response res) {
    message = jDecode(res.body)["message"];
  }
}

class AddViolationSuccessState extends AddViolationState {}

class AddViolationBloc extends Bloc<AddViolationEvent, AddViolationState> {
  AddViolationBloc() : super(AddViolationInitState()) {
    on(_onEvent);
  }

  FutureOr<void> _onEvent(AddViolationEvent event, Emitter<AddViolationState> emit) async {
    emit(AddViolationLoadingState());

    var res = await http2.postJsonWithToken(
      getFileUrl("violation/addViolation/"),
      body: {
        "fileId": event.fileId,
        "title": event.title,
        "body": event.body,
      },
    );

    if (!isResponseOk(res)) return emit(AddViolationErrorState(res));

    return emit(AddViolationErrorState(res));
  }
}
