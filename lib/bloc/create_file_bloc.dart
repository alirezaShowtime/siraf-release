import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
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
  StreamedResponse? response;

  CreateFileErrorState({this.response});
}

class CreateFileBloc extends Bloc<CreateFileEvent, CreateFileState> {
  CreateFileBloc() : super(CreateFileInitState()) {
    on(_onEvent);
  }

  _onEvent(CreateFileEvent event, emit) async {
    emit(CreateFileLoadingState());

    StreamedResponse response;

    try {
      var headers = {
        'Content-Type': 'application/json',
        "Authorization": await User.getBearerToken(),
      };

      var request = MultipartRequest(
          'POST',
          event.data.estates.isEmpty
              ? getFileUrl("file/addFileSiraf/")
              : getFileUrl("file/addFileEstate/"));

      request.headers.addAll(headers);

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

      request.fields.addAll({
        'name': event.data.title,
        'long': event.data.location.longitude.toString(),
        'lat': event.data.location.latitude.toString(),
        'address': event.data.address,
        'city_id': event.data.city.id!.toString(),
        'category_id': event.data.category.id!.toString(),
        'fetcher': jsonEncode(event.data.properties),
        if (videos.isNotEmpty)
          'videosName':
              jsonEncode(videos.map((e) => e['title'] as String?).toList()),
        if (images.isNotEmpty)
          'imagesName':
              jsonEncode(images.map((e) => e['title'] as String?).toList()),
        'description': event.data.description,
        'visitPhoneNumber': '09127777777',
        'ownerPhoneNumber': '09127777777'
      });
      if (images.isNotEmpty) {
        for (Map<String, dynamic> item in images) {
          request.files.add(await MultipartFile.fromPath(
              'images', (item['file'] as io.File).path));
        }
      }
      if (videos.isEmpty) {
        for (Map<String, dynamic> item in videos) {
          request.files.add(await MultipartFile.fromPath(
              'videos', (item['file'] as io.File).path));
        }
      }

      if (tour != null) {
        request.files.add(await MultipartFile.fromPath(
            'virtualTour', (tour['file'] as io.File).path));
      }

      response = await request.send();
    } on HttpException catch (e) {
      emit(CreateFileErrorState());
      return;
    } on SocketException catch (e) {
      emit(CreateFileErrorState());
      return;
    }

    print(response.reasonPhrase);

    if (response.statusCode < 400) {
      emit(CreateFileLoadedState());
    } else {
      emit(CreateFileErrorState(response: response));
    }
  }
}
