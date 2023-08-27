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

class EstateFilesBloc extends Bloc<FilesEvent, FilesState> {
  EstateFilesBloc() : super(FilesInitState()) {
    on(_onEvent);
  }

  _onEvent(event, emit) async {
    if (event is FilesLoadEvent) {
      emit(FilesLoadingState());

      var url = getFileUrl('file/filesEstate?estateId=${event.filterData.estateId}${event.filterData.toQueryString(delimiter: "&")}&lastId=${event.lastId}');

      Response response = await http2.get(url, timeout: Duration(seconds: 60));

      if (isResponseOk(response)) {
        var json = jDecode(response.body);

        if (json['data'] == null || json['data'] == "") {
          emit(FilesLoadedState(files: [], lastId: null));
        } else {
          var files = File.fromList(json['data']['files']).toList();
          var lastId = json['data']["lastId"] as int?;
          emit(FilesLoadedState(files: files, lastId: lastId));
        }
      } else {
        emit(FilesErrorState(response: response));
      }
    }
  }
}
