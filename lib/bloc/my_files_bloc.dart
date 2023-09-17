import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/my_file.dart';

class MyFilesEvent {
  String? sort;
  String? filter;

  MyFilesEvent({this.sort, this.filter});
}

class MyFilesState {}

class MyFilesInitState extends MyFilesState {}

class MyFilesLoadingState extends MyFilesState {}

class MyFilesLoadedState extends MyFilesState {
  List<MyFile> files;
  String? sort;

  MyFilesLoadedState({required this.files, this.sort});
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

    if (event.sort != "new" && event.sort != "old") {
      event.filter = event.sort;
      event.sort = null;
    }

    try {
      response = await http2.getWithToken(
          getFileUrl(
            "file/myFiles/" + (event.sort.isFill() ? "?sort=${event.sort!}" : "") + (event.filter.isFill() ? "?filter=${event.filter!}" : ""),
          ),
          timeout: Duration(seconds: 5000));
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

      emit(MyFilesLoadedState(files: files, sort: event.sort ?? event.filter));
    } else {
      emit(MyFilesErrorState(response: response));
    }
  }
}
