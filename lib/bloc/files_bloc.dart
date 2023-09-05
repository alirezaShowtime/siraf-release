import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/models/user.dart';

class FilesEvent {}

class FilesLoadEvent extends FilesEvent {
  FilterData filterData;
  int lastId;

  FilesLoadEvent({required this.filterData, this.lastId = 0});
}

class FilesState {}

class FilesInitState extends FilesState {}

class FilesLoadingState extends FilesState {}

class FilesLoadedState extends FilesState {
  List<File> files;
  int? lastId;

  FilesLoadedState({required this.files, this.lastId});
}

class FilesErrorState extends FilesState {
  Response? response;

  String? message;

  FilesErrorState({required this.response}) {
    message = jDecode(response!.body)['message'];
  }
}

class FilesBloc extends Bloc<FilesEvent, FilesState> {
  FilesBloc() : super(FilesInitState()) {
    on(_onEvent);
  }

  _onEvent(event, emit) async {
    if (event is FilesLoadEvent) {
      emit(FilesLoadingState());

      Response response;

      var url = getFileUrl('file/files/' + event.filterData.toQueryString() + '&lastId=' + event.lastId.toString());

      if (await User.hasToken()) {
        response = await http2.getWithToken(url, timeout: Duration(seconds: 60));
      } else {
        response = await http2.get(url, timeout: Duration(seconds: 60));
      }

      if (isResponseOk(response)) {
        var json = jDecode(response.body);

        if (json['data'] == null || json['data'] == "" || json['data'] == []) {
          emit(FilesLoadedState(files: [], lastId: null));
        } else {
          var files = File.fromList(json['data']['files']).toList();
          var lastId = json['data']["lastId"] as int?;
          emit(FilesLoadedState(files: files, lastId: lastId));
        }
      } else {
        var json = jDecode(response.body);

        if (json['code'] == 205) {
          User.remove();

          response = await http2.get(url, timeout: Duration(seconds: 60));

          if (isResponseOk(response)) {
            var json = jDecode(response.body);
            var files = File.fromList(json['data']['files']);

            emit(FilesLoadedState(files: files, lastId: json['data']["lastId"] as int));
          } else {
            emit(FilesErrorState(response: response));
          }
        } else {
          emit(FilesErrorState(response: response));
        }
      }
    }
  }
}
