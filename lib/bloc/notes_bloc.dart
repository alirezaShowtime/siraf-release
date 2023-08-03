import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/note.dart';

class NotesEvent {}

class NotesState {}

class NotesInitState extends NotesState {}

class NotesLoadingState extends NotesState {}

class NotesLoadedState extends NotesState {
  List<Note> notes;

  NotesLoadedState({required this.notes});
}

class NotesErrorState extends NotesState {
  Response response;

  NotesErrorState({required this.response});
}

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc(): super(NotesInitState()) {
    on(_onEvent);
  }

  _onEvent(NotesEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoadingState());

    var response = await http2.getWithToken(getFileUrl("note/notes"));

    if (isResponseOk(response)) {
      var json = jDecode(response.body);

      var notes = Note.fromList(json['data']);

      emit(NotesLoadedState(notes: notes));
    } else {
      emit(NotesErrorState(response: response));
    }
  }
}