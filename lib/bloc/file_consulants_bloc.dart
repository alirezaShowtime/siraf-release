import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file_consulant.dart';

class FileConsulantsEvent {}

class FileConsulantsLoadEvent extends FileConsulantsEvent {}

class FileConsulantsState {}

class FileConsulantsInitState extends FileConsulantsState {}

class FileConsulantsLoadingState extends FileConsulantsState {}

class FileConsulantsLoadedState extends FileConsulantsState {
  List<FileConsulant> consultants;

  FileConsulantsLoadedState({required this.consultants});
}

class FileConsulantsErrorState extends FileConsulantsState {
  Response? response;

  FileConsulantsErrorState({required this.response});
}

class FileConsulantsBloc
    extends Bloc<FileConsulantsEvent, FileConsulantsState> {
  FileConsulantsBloc() : super(FileConsulantsInitState()) {
    on(_onEvent);
  }

  _onEvent(event, emit) async {
    emit(FileConsulantsLoadingState());

    var response;

    try {
      response = await get(getEstateUrl("consultant/consultantsFile?fileId=1"));
    } on HttpException catch (_) {
      emit(FileConsulantsErrorState(response: null));
      return;
    }

    if (isResponseOk(response)) {
      print(response.body);
      var json = jDecode(response.body);

      emit(
        FileConsulantsLoadedState(
          consultants: FileConsulant.fromList(json['data']),
        ),
      );
    } else {
      emit(FileConsulantsErrorState(response: response));
    }
  }
}
