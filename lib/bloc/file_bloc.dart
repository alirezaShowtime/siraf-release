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

  FileLoadedState(Response res, bool favorite) {
    var data = jDecode(res.body);
    file = FileDetail.fromJson(data['data']);
    this.favorite = favorite;
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

    var url = getFileUrl('file/file/${event.id}/');

    var isLoggedIn = (await User.hasToken());

    var res = isLoggedIn ? await http2.getWithToken(url) : await http2.get(url);

    bool favorite = false;

    if (isLoggedIn) {
      var resp = await http2.getWithToken(getFileUrl("file/checkFavorite/${event.id}/"));
      
      if (isResponseOk(resp))
        favorite = (jDecode(resp.body)['data'] as bool);
    }

    if (isResponseOk(res)) {
      return emit(FileLoadedState(res, favorite));
    }

    var json = jDecode(res.body);

    if (json['code'] != 205) {
      return emit(FileErrorState(res));
    }

    User.remove();

    res = await http2.get(url);

    if (isResponseOk(res)) {
      return emit(FileLoadedState(res, false));
    }
    return emit(FileErrorState(res));
  }
}
