import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/file_compare.dart';

class CompareEvent {
  List<File> files;

  CompareEvent({required this.files});
}

class CompareState {}

class CompareInitState extends CompareState {}

class CompareLoadingState extends CompareState {}

class CompareLoadedState extends CompareState {
  List<FileCompare> files;

  CompareLoadedState({required this.files});
}

class CompareErrorState extends CompareState {
  Response response;

  CompareErrorState({required this.response});
}

class CompareBloc extends Bloc<CompareEvent, CompareState> {
  CompareBloc() : super(CompareInitState()) {
    on(_onEvent);
  }

  _onEvent(CompareEvent event, Emitter<CompareState> emit) async {
    emit(CompareLoadingState());

    var response = await http2.getWithToken(
      getFileUrl(
        "file/fileComparison?ids=" + jsonEncode(event.files.map((e) => e.id).toList()),
      ),
    );

    if (isResponseOk(response)) {
      var json = jDecode(response.body);

      var files = FileCompare.fromList(json['data']);

      files = files.map((e) {
        e.file = event.files.any((element) => element.id == e.id) ? event.files.firstWhere((element) => element.id == e.id) : null;
        return e;
      }).toList();

      emit(CompareLoadedState(files: files));
    } else {
      emit(CompareErrorState(response: response));
    }
  }
}
