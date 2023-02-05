import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:siraf3/helpers.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:siraf3/models/edit_file_form_data.dart';
import 'package:siraf3/models/user.dart';

class EditFileEvent {
  EditFileFormData data;

  EditFileEvent({required this.data});
}

class EditFileState {}

class EditFileInitState extends EditFileState {}

class EditFileLoadingState extends EditFileState {}

class EditFileSuccessState extends EditFileState {}

class EditFileErrorState extends EditFileState {
  Response? response;

  EditFileErrorState({this.response});
}

class EditFileBloc extends Bloc<EditFileEvent, EditFileState> {
  EditFileBloc() : super(EditFileInitState()) {
    on(_onEvent);
  }

  _onEvent(EditFileEvent event, emit) async {
    emit(EditFileLoadingState());

    Response response;

    try {
      var headers = {
        "Authorization": await User.getBearerToken(),
      };

      var formData = FormData.fromMap({
        'name': event.data.title,
        'long': event.data.location.longitude.toString(),
        'lat': event.data.location.latitude.toString(),
        'address': event.data.address,
        'city_id': event.data.city.id!.toString(),
        'category_id': event.data.category.id!.toString(),
        'fetcher': jsonEncode(event.data.properties),
        'description': event.data.description,
        'visitPhoneNumber': event.data.visitPhone,
        'ownerPhoneNumber': event.data.ownerPhone,
        if (event.data.estates.isNotEmpty)
          'estateIds':
              jsonEncode(event.data.estates.map((e) => e.id!).toList()),
      });

      var url = getFileUrl("file/editeFile/${event.data.id}/").toString();

      print(url);
      print(headers);
      print(formData.fields);
      print(formData.files);

      response = await Dio().post(
        url,
        options: Options(
          validateStatus: (status) {
            return true;
          },
          headers: headers,
        ),
        data: formData,
      );
    } on HttpException catch (e) {
      emit(EditFileErrorState());
      return;
    } on SocketException catch (e) {
      emit(EditFileErrorState());
      return;
    } on DioError catch (e) {
      emit(EditFileErrorState());
      return;
    }

    print(response.statusCode);
    print(response.statusMessage);
    print(response.data);

    if (response.data['status'] == 1) {
      emit(EditFileSuccessState());
    } else {
      emit(EditFileErrorState(response: response));
    }
  }
}
