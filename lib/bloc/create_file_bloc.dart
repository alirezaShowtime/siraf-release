import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/create_file_form_data.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;
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

      var videos = event.data.files
          .where((element) =>
              checkVideoExtension((element['file'] as io.File).path))
          .toList();

      var images = event.data.files
          .where((element) =>
              checkImageExtension((element['file'] as io.File).path))
          .toList();

      var tours = event.data.files
          .where((element) =>
              p.extension((element['file'] as io.File).path) == "zip")
          .toList();
      var tour = tours.isNotEmpty ? tours.first : null;

      var formData = FormData.fromMap({
        'name': event.data.title,
        'long': event.data.location.longitude.toString(),
        'lat': event.data.location.latitude.toString(),
        'address': event.data.address,
        'city_id': event.data.city.id!.toString(),
        'category_id': event.data.category.id!.toString(),
        'fetcher': jsonEncode(event.data.properties),
        if (videos.isNotEmpty)
          'videosName': jsonEncode(
              videos.map((e) => (e['title'] as String?) ?? "").toList()),
        if (images.isNotEmpty)
          'imagesName': jsonEncode(
              images.map((e) => (e['title'] as String?) ?? "").toList()),
        'description': event.data.description,
        'visitPhoneNumber': event.data.visitPhone,
        'ownerPhoneNumber': event.data.ownerPhone,
        if (event.data.estates.isNotEmpty)
          'estateIds':
              jsonEncode(event.data.estates.map((e) => e.id!).toList()),
      });

      formData.files.addAll([
        for (Map<String, dynamic> item in images)
          MapEntry<String, MultipartFile>("images",
              await MultipartFile.fromFile((item['file'] as io.File).path)),
        for (Map<String, dynamic> item in videos)
          MapEntry<String, MultipartFile>("videos",
              await MultipartFile.fromFile((item['file'] as io.File).path)),
        if (tour != null)
          MapEntry("virtualTour",
              await MultipartFile.fromFile((tour['file'] as io.File).path)),
      ]);

      var url = event.data.estates.isEmpty
          ? getFileUrl("file/addFileSiraf/").toString()
          : getFileUrl("file/addFileEstate/").toString();

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
      emit(CreateFileErrorState());
      return;
    } on SocketException catch (e) {
      emit(CreateFileErrorState());
      return;
    } on DioError catch (e) {
      emit(CreateFileErrorState());
      return;
    }

    print(response.statusCode);
    print(response.statusMessage);
    print(response.data);

    if (response.data['status'] == 1) {
      emit(CreateFileLoadedState());
    } else {
      emit(CreateFileErrorState(response: response));
    }
  }
}
