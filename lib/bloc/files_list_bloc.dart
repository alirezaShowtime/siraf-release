import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/models/user.dart';

class FilesListEvent {}

class FilesListLoadEvent extends FilesListEvent {
  FilterData filterData;
  int lastId;

  FilesListLoadEvent({required this.filterData, this.lastId = 0});
}

class FilesListState {}

class FilesListInitState extends FilesListState {}

class FilesListLoadingState extends FilesListState {}

class FilesListLoadedState extends FilesListState {
  List<File> files;
  int? lastId;

  FilesListLoadedState({required this.files, this.lastId});
}

class FilesListErrorState extends FilesListState {
  Response? response;

  FilesListErrorState({required this.response});
}

class FilesListBloc extends Bloc<FilesListEvent, FilesListState> {
  FilesListBloc() : super(FilesListInitState()) {
    on(_onEvent);
  }

  _onEvent(event, emit) async {
    if (event is FilesListLoadEvent) {
      emit(FilesListLoadingState());

      Response response;

      var url = getFileUrl('file/files/' +
          event.filterData.toQueryString() +
          '&lastId=' +
          event.lastId.toString());

      if (await User.hasToken()) {
        response =
            await http2.getWithToken(url, timeout: Duration(seconds: 60));
      } else {
        response = await http2.get(url, timeout: Duration(seconds: 60));
      }

      if (isResponseOk(response)) {
        var json = jDecode(response.body);
        var files = File.fromList(json['data']['files']).toList();

        emit(
            FilesListLoadedState(files: files, lastId: json['data']["lastId"] as int?));
      } else {
        var json = jDecode(response.body);

        if (json['code'] == 205) {
          User.remove();

          response = await http2.get(url, timeout: Duration(seconds: 60));

          if (isResponseOk(response)) {
            var json = jDecode(response.body);
            var files = File.fromList(json['data']['files']);

            emit(FilesListLoadedState(
                files: files, lastId: json['data']["lastId"] as int));
          } else {
            emit(FilesListErrorState(response: response));
          }
        } else {
          emit(FilesListErrorState(response: response));
        }
      }
    }
  }
}
