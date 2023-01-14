import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/user.dart';

class HSEvent {}

class HSLoadEvent extends HSEvent {
  List<City> cities;

  HSLoadEvent({required this.cities});
}

class HSState {}

class HSInitState extends HSState {}

class HSLoadingState extends HSState {}

class HSLoadedState extends HSState {
  List<File> files;

  HSLoadedState({required this.files});
}

class HSErrorState extends HSState {
  Response response;

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
          '&lastId=0');

      if (await User.hasToken()) {
        response = await get(url, headers: {
          // "Authorization": await User.getBearerToken(),
        });
      } else {
        response = await get(url);
      }

      if (isResponseOk(response)) {
        var json = jDecode(response.body);
        emit(HSLoadedState(files: File.fromList(json['data']['files'])));
      } else {
        var json = jDecode(response.body);

        if (json['code'] == 205) {
          User.remove();

          response = await get(url);

          if (isResponseOk(response)) {
            var json = jDecode(response.body);

            emit(HSLoadedState(files: File.fromList(json['data']['files'])));
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
