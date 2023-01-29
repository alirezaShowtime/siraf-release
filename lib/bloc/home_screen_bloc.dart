import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/user.dart';

class HSEvent {}

class HSLoadEvent extends HSEvent {
  List<City> cities;
  int lastId;

  HSLoadEvent({required this.cities, this.lastId = 0});
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

      var response;

      var url = getFileUrl('file/files/?cityIds=' +
          jsonEncode(event.cities.map((e) => e.id).toList()) +
          '&lastId=' +
          event.lastId.toString());

      print(url.toString());

      try {
        if (await User.hasToken()) {
          response = await get(url, headers: {
            "Authorization": await User.getBearerToken(),
          });
        } else {
          response = await get(url);
        }
      } on HttpException catch (e) {
        emit(HSErrorState(response: null));
        return;
      } on SocketException catch (e) {
        emit(HSErrorState(response: null));
        return;
      }

      if (isResponseOk(response)) {
        var json = jDecode(response.body);
        var files = File.fromList(json['data']['files']).toList();

        emit(
            HSLoadedState(files: files, lastId: json['data']["lastId"] as int));
      } else {
        var json = jDecode(response.body);

        if (json['code'] == 205) {
          User.remove();

          response = await get(url);

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
