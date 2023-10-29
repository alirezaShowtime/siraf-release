import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/file_consultant.dart';

class FileConsulantsEvent {
  int id;

  FileConsulantsEvent({required this.id});
}

class FileConsulantsLoadEvent extends FileConsulantsEvent {
  FileConsulantsLoadEvent({required super.id});
}

class FileConsulantsState {}

class FileConsulantsInitState extends FileConsulantsState {}

class FileConsulantsLoadingState extends FileConsulantsState {}

class FileConsulantsLoadedState extends FileConsulantsState {
  List<FileConsultant> consultants;

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

  _onEvent(FileConsulantsEvent event, emit) async {
    emit(FileConsulantsLoadingState());

    var response;

    try {
      response = await http2
          .get(getEstateUrl("consultant/consultantsFile?fileId=${event.id}"));
    } on HttpException catch (_) {
      emit(FileConsulantsErrorState(response: null));
      return;
    } on SocketException catch (e) {
      emit(FileConsulantsErrorState(response: null));
      return;
    }

    if (isResponseOk(response)) {
      var json = jDecode(response.body);

      emit(
        FileConsulantsLoadedState(
          consultants: FileConsultant.fromList(json['data']),
        ),
      );
    } else {
      emit(FileConsulantsErrorState(response: response));
    }
  }
}
