import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/user.dart';

class DeleteFileEvent {
  String token;

  DeleteFileEvent({required this.token});
}

class DeleteFileListEvent extends DeleteFileEvent {
  List<int> ids;

  DeleteFileListEvent({required this.ids,required token}) : super (token: token);
}

class DeleteFileSingleEvent extends DeleteFileEvent {
  int id;

  DeleteFileSingleEvent({required this.id,required token}) : super (token: token);
}

class DeleteFileState {}

class DeleteFileInitState extends DeleteFileState {}

class DeleteFileLoadingState extends DeleteFileState {}

class DeleteFileErrorState extends DeleteFileState {
  Response? response;

  DeleteFileErrorState({this.response});
}

class DeleteFileSuccessState extends DeleteFileState {}

class DeleteFileBloc extends Bloc<DeleteFileEvent, DeleteFileState> {
  DeleteFileBloc() : super(DeleteFileInitState()) {
    on(_onEvent);
  }

  FutureOr<void> _onEvent(
      DeleteFileEvent event, Emitter<DeleteFileState> emit) async {
    List<int> ids = [];
    if (event is DeleteFileSingleEvent) {
      ids = [event.id];
    } else if (event is DeleteFileListEvent) {
      ids = event.ids;
    }

    emit(DeleteFileLoadingState());

    Response response;

    try {
      response = await http2.get(
          getFileUrl(
            "file/removeFile?listFile=" + jsonEncode(ids),
          ),
          headers: {
            "Authorization": event.token,
          });
    } on HttpException catch (e) {
      emit(DeleteFileErrorState());
      return;
    } on SocketException catch (e) {
      emit(DeleteFileErrorState());
      return;
    }

    print(response.body);

    if (isResponseOk(response)) {
      emit(DeleteFileSuccessState());
    } else {
      emit(DeleteFileErrorState(response: response));
    }
  }
}
