import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file_detail.dart';
import 'package:siraf3/models/user.dart';

class FileEvent {}

class FileFetchEvent extends FileEvent {
  int id;

  FileFetchEvent({required this.id});
}

class FileState {}

class FileInitState extends FileState {}

class FileLoadingState extends FileState {}

class FileLoadedState extends FileState {
  FileDetail file;
  bool? favorite;

  FileLoadedState({required this.file, required this.favorite});
}

class FileErrorState extends FileState {
  Response? response;

  FileErrorState({required this.response});
}

class FileBloc extends Bloc<FileEvent, FileState> {
  FileBloc() : super(FileInitState()) {
    on(_onEvent);
  }

  _onEvent(event, emit) async {
    emit(FileLoadingState());

    try {
      var response;

      var url = getFileUrl('file/file/' + event.id.toString());

      if (await User.hasToken()) {
        response = await get(url, headers: {
          "Authorization": await User.getBearerToken(),
        });
      } else {
        response = await get(url);
      }

      var json = jDecode(response.body);

      print(json);

      if (isResponseOk(response)) {
        var json = jDecode(response.body);
        emit(FileLoadedState(
            file: FileDetail.fromJson(json['data']),
            favorite: json['data']['favorite']));
      } else {
        var json = jDecode(response.body);

        if (json['code'] == 205) {
          User.remove();

          response = await get(url);

          if (isResponseOk(response)) {
            var json = jDecode(response.body);

            emit(FileLoadedState(
                file: FileDetail.fromJson(json['data']['files']),
                favorite: json['data']['favorite']));
          } else {
            emit(FileErrorState(response: response));
          }
        } else {
          emit(FileErrorState(response: response));
        }
      }
    } on HttpException catch (e) {
      print(e);
      emit(FileErrorState(response: null));
    }
  }
}
