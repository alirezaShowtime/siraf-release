import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/file_consultant.dart';
import 'package:siraf3/models/my_file_detail.dart';
import 'package:siraf3/models/user.dart';
import 'package:http/http.dart';

class MyFileEvent {}

class MyFileFetchEvent extends MyFileEvent {
  int id;
  int progress;

  MyFileFetchEvent({required this.id, required this.progress});
}

class MyFileState {}

class MyFileInitState extends MyFileState {}

class MyFileLoadingState extends MyFileState {}

class MyFileLoadedState extends MyFileState {
  MyFileDetail file;
  bool? favorite;
  List<FileConsultant> consultants;

  MyFileLoadedState({required this.file, required this.favorite, required this.consultants});
}

class MyFileErrorState extends MyFileState {
  String? message;

  MyFileErrorState([Response? res]) {
    if (res != null) {
      message = jDecode(res.body)["message"];
    }
  }
}

class MyFileBloc extends Bloc<MyFileEvent, MyFileState> {
  MyFileBloc() : super(MyFileInitState()) {
    on(_onEvent);
  }

  _onEvent(MyFileEvent event, emit) async {
    if (event is MyFileFetchEvent) {
      emit(MyFileLoadingState());

      try {
        var response;

        var url = getFileUrl('file/myFile/' + event.id.toString());

        response = await http2.getWithToken(url);

        List<FileConsultant> consultants = [];

        if (event.progress == 7) {
          var response2 = await http2.get(getEstateUrl("consultant/consultantsFile?fileId=${event.id}"));

          if (isResponseOk(response2)) {
            var json2 = jDecode(response2.body);
            consultants = !(json2['data'] is String) ? FileConsultant.fromList(json2['data']) : [];
          }
        }

        if (isResponseOk(response)) {
          var json = jDecode(response.body);

          var fileDetail = MyFileDetail.fromJson(json['data']);

          emit(
            MyFileLoadedState(
              file: fileDetail,
              favorite: json['data']['favorite'],
              consultants: consultants,
            ),
          );
        } else {
          var json = jDecode(response.body);

          if (json['code'] == 205) {
            User.remove();

            response = await http2.get(url);

            if (isResponseOk(response)) {
              var json = jDecode(response.body);

              emit(
                MyFileLoadedState(
                  file: MyFileDetail.fromJson(json['data']),
                  favorite: json['data']['favorite'],
                  consultants: consultants,
                ),
              );
            } else {
              emit(MyFileErrorState(response));
            }
          } else {
            emit(MyFileErrorState(response));
          }
        }
      } on HttpException catch (e) {
        print(e);
        emit(MyFileErrorState());
      } on SocketException catch (e) {
        print(e);
        emit(MyFileErrorState());
      }
    }
  }
}
