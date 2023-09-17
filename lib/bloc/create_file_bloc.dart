import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/create_file_form_data.dart';
import 'package:siraf3/models/user.dart';

class CreateFileEvent {
  CreateFileFormData data;

  CreateFileEvent({required this.data});
}

class CreateFileState {}

class CreateFileInitState extends CreateFileState {}

class CreateFileLoadingState extends CreateFileState {}

class CreateFileLoadedState extends CreateFileState {}

class CreateFileErrorState extends CreateFileState {
  Response? response;

  CreateFileErrorState({this.response});
}

class CreateFileBloc extends Bloc<CreateFileEvent, CreateFileState> {
  CreateFileBloc() : super(CreateFileInitState()) {
    on(_onEvent);
  }

  _onEvent(CreateFileEvent event, emit) async {
    emit(CreateFileLoadingState());

    Response response;

    try {
      var headers = {
        "content-type": "multipart/form-data",
        "Authorization": await User.getBearerToken(),
      };

      var url = event.data.estates.isEmpty ? getFileUrl("file/addFileSiraf/").toString() : getFileUrl("file/addFileEstate/").toString();

      print("CRAETE FILE : " + url);

      response = await Dio().post(
        url,
        options: Options(
          validateStatus: (status) {
            return true;
          },
          headers: headers,
        ),
        data: await event.data.getFormData(),
      );
    } on HttpException catch (e) {
      emit(CreateFileErrorState());
      return;
    } on SocketException catch (e) {
      emit(CreateFileErrorState());
      return;
    } on DioError catch (e) {
      emit(CreateFileErrorState());
      return;
    }

    if (response.data['status'] == 1) {
      emit(CreateFileLoadedState());
    } else {
      emit(CreateFileErrorState(response: response));
    }
  }
}
