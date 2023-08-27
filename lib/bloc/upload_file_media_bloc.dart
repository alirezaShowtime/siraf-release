import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:siraf3/helpers.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:siraf3/models/edit_file_form_data.dart' as eData;
import 'package:siraf3/models/user.dart';

class UFMEvent {
  int id;
  eData.MediaData media;

  UFMEvent({required this.id, required this.media});
}

class UFMState {}

class UFMInitState extends UFMState {}

class UFMLoadingState extends UFMState {}

class UFMSuccessState extends UFMState {}

class UFMErrorState extends UFMState {
  Response? response;

  UFMErrorState({this.response});
}

class UFMBloc extends Bloc<UFMEvent, UFMState> {
  UFMBloc() : super(UFMInitState()) {
    on(_onEvent);
  }

  _onEvent(UFMEvent event, emit) async {
    emit(UFMLoadingState());

    Response response;

    try {
      var headers = {
        "content-type": "multipart/form-data",
        "Authorization": await User.getBearerToken(),
      };


      var url = getFileUrl("file/uploadFile/${event.id}/").toString();

      response = await Dio().post(
        url,
        options: Options(
          validateStatus: (status) {
            return true;
          },
          headers: headers,
        ),
        data: await event.media.getFormData(),
      );
    } on HttpException catch (e) {
      emit(UFMErrorState());
      return;
    } on SocketException catch (e) {
      emit(UFMErrorState());
      return;
    } on DioError catch (e) {
      emit(UFMErrorState());
      return;
    }

    print(response.statusCode);
    print(response.statusMessage);
    print(response.data);

    if (response.data['status'] == 1) {
      emit(UFMSuccessState());
    } else {
      emit(UFMErrorState(response: response));
    }
  }
}
