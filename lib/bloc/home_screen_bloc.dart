import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/models/user.dart';

class HSEvent {}

class HSLoadEvent extends HSEvent {
  FilterData filterData;
  int lastId;

  HSLoadEvent({required this.filterData, this.lastId = 0});
}

class HSState {}

class HSInitState extends HSState {}

class HSLoadingState extends HSState {}

class HSLoadedState extends HSState {
  List<File> files;
  int? lastId;

  HSLoadedState({required this.files, this.lastId});
}

class HSErrorState extends HSState {
  Response? response;

  HSErrorState({required this.response});
}

class HSBloc extends Bloc<HSEvent, HSState> {
  HSBloc() : super(HSInitState()) {
    on(_onEvent);
  }

  _onEvent(event, emit) async {
    if (event is HSLoadEvent) {
      emit(HSLoadingState());

      Response response;

      var url = getFileUrl('file/files/' +
          event.filterData.toQueryString() +
          '&lastId=' +
          event.lastId.toString());

      print(url.toString());

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
            HSLoadedState(files: files, lastId: json['data']["lastId"] as int));
      } else {
        var json = jDecode(response.body);

        print(convertUtf8(response.body));

        if (json['code'] == 205) {
          User.remove();

          response = await http2.get(url, timeout: Duration(seconds: 60));

          if (isResponseOk(response)) {
            var json = jDecode(response.body);
            var files = File.fromList(json['data']['files']);

            emit(HSLoadedState(
                files: files, lastId: json['data']["lastId"] as int));
          } else {
            emit(HSErrorState(response: response));
          }
        } else {
          emit(HSErrorState(response: response));
        }
      }
    }
  }
}
