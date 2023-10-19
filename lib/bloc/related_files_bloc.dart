import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/file.dart';

class RelatedFilesEvent {
  int id;

  RelatedFilesEvent({required this.id});
}

class RelatedFilesState {}

class RelatedFilesInitState extends RelatedFilesState {}

class RelatedFilesLoadingState extends RelatedFilesState {}

class RelatedFilesLoadedState extends RelatedFilesState {
  List<File> files;

  RelatedFilesLoadedState({required this.files});
}

class RelatedFilesErrorState extends RelatedFilesState {
  Response response;

  RelatedFilesErrorState({required this.response});
}

class RelatedFilesBloc extends Bloc<RelatedFilesEvent, RelatedFilesState> {
  RelatedFilesBloc(): super(RelatedFilesInitState()) {
    on(_onEvent);
  }

  _onEvent(RelatedFilesEvent event, Emitter<RelatedFilesState> emit) async {
    emit(RelatedFilesLoadingState());

    var response = await http2.get(getFileUrl("file/similarFiles?fileId=${event.id}"));

    if (isResponseOk(response)) {
      var json = jDecode(response.body);

      var files = File.fromList(json['data']);

      files.removeWhere((element) => element.id == event.id);

      emit(RelatedFilesLoadedState(files: files));
    } else {
      emit(RelatedFilesErrorState(response: response));
    }
  }
}


