import 'package:http/http.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file_view.dart';

class FVCEvent {
  int id;

  FVCEvent({required this.id});
}

class FVCState {}

class FVCInitState extends FVCState {}

class FVCLoadingState extends FVCState {}

class FVCLoadedState extends FVCState {
  List<FileView> views;

  FVCLoadedState({required this.views});
}

class FVCErrorState extends FVCState {
  Response response;

  FVCErrorState({required this.response});
}

class FVCBloc extends Bloc<FVCEvent, FVCState> {
  FVCBloc() : super(FVCInitState()) {
    on(_onEvent);
  }

  _onEvent(FVCEvent event, emit) async {
    emit(FVCLoadingState());

    var response = await http2.getWithToken(getFileUrl("fileView/fileView/${event.id}"));

    if (isResponseOk(response)) {
      var body = jDecode(response.body);

      emit(FVCLoadedState(views: FileView.fromList(body['data'])));
    } else {
      emit(FVCErrorState(response: response));
    }
  }
}
