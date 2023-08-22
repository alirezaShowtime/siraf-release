import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/file_detail.dart';
import 'package:siraf3/models/user.dart';

class FileEvent {}

class FileFetchEvent extends FileEvent {
  int id;

  FileFetchEvent({required this.id});
}

class FileState {}

class FileInitState extends FileState {}

class FileLoadingState extends FileState {}

class FileLoadedState extends FileState {
  late FileDetail file;
  bool favorite = false;

  FileLoadedState(Response res) {
    var data = jDecode(res.body);
    file = FileDetail.fromJson(data['data']);
    favorite = data['data']['favorite'] ?? false;
  }
}

class FileErrorState extends FileState {
  String? message;

  FileErrorState(Response res) {
    message = jDecode(res.body)["message"];
  }
}

class FileBloc extends Bloc<FileEvent, FileState> {
  FileBloc() : super(FileInitState()) {
    on(_onEvent);
  }

  _onEvent(event, emit) async {
    emit(FileLoadingState());

    var url = getFileUrl('file/file/' + event.id.toString());

    var res = (await User.hasToken()) ? await http2.getWithToken(url) : await http2.get(url);

    if (isResponseOk(res)) {
      return emit(FileLoadedState(res));
    }

    var json = jDecode(res.body);

    if (json['code'] != 205) {
      return emit(FileErrorState(res));
    }

    User.remove();

    res = await http2.get(url);

    if (isResponseOk(res)) {
      return emit(FileLoadedState(res));
    }
    return emit(FileErrorState(res));
  }
}
