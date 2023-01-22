import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/my_file.dart';
import 'package:siraf3/models/user.dart';

class MyFilesEvent {}

class MyFilesState {}

class MyFilesInitState extends MyFilesState {}

class MyFilesLoadingState extends MyFilesState {}

class MyFilesLoadedState extends MyFilesState {
  List<MyFile> files;

  MyFilesLoadedState({required this.files});
}

class MyFilesErrorState extends MyFilesState {
  Response? response;

  MyFilesErrorState({required this.response});
}

class MyFilesBloc extends Bloc<MyFilesEvent, MyFilesState> {
  MyFilesBloc() : super(MyFilesInitState()) {
    on(_onEvent);
  }

  FutureOr<void> _onEvent(
      MyFilesEvent event, Emitter<MyFilesState> emit) async {
    emit(MyFilesLoadingState());

    Response response;

    try {
      response = await get(getFileUrl("file/myFiles"), headers: {
        "Authorization": await User.getBearerToken(),
      });
    } on HttpException catch (e) {
      emit(MyFilesErrorState(response: null));
      return;
    } on SocketException catch (e) {
      emit(MyFilesErrorState(response: null));
      return;
    }

    if (isResponseOk(response)) {
      var json = jDecode(response.body);

      var files = MyFile.fromList(json['data']);

      emit(MyFilesLoadedState(files: files));
    } else {
      emit(MyFilesErrorState(response: response));
    }
  }
}
