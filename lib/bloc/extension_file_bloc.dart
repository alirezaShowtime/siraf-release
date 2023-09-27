import 'dart:convert';

import 'package:siraf3/helpers.dart';
import 'package:bloc/bloc.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:http/http.dart';

class ExtensionFileEvent {
  int id;

  ExtensionFileEvent({required this.id});
}

class ExtensionFileState {}

class ExtensionFileInitialState extends ExtensionFileState {}

class ExtensionFileLoadingState extends ExtensionFileState {}

class ExtensionFileSuccessState extends ExtensionFileState {}

class ExtensionFileErrorState extends ExtensionFileState {
  Response response;

  String message = "";

  ExtensionFileErrorState({required this.response}) {
    if (response.statusCode < 500) {
      message = (jDecode(response.body)['message'] as String?) ?? "خطایی در تمدید رخ داد لطفا بعدا مجدد تلاش کنید";
    }
  }
}

class ExtensionFileBloc extends Bloc<ExtensionFileEvent, ExtensionFileState> {
  ExtensionFileBloc(): super(ExtensionFileInitialState()) {
    on(_onEvent);
  }

  _onEvent(ExtensionFileEvent event, emit) async {
    emit(ExtensionFileLoadingState);

    var response = await http2.getWithToken(getFileUrl("file/revivalfile/${event.id}"));

    if (!isResponseOk(response)) {
      emit(ExtensionFileErrorState(response: response));
      return;
    }

    emit(ExtensionFileSuccessState());
  }
}