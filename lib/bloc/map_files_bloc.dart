import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:siraf3/http2.dart' as http2;

class MapFilesEvent {}

class MapFilesState {}

class MapFilesInitState extends MapFilesState {}

class MapFilesLoadingState extends MapFilesState {}

class MapFilesLoadedState extends MapFilesState {}

class MapFilesErrorState extends MapFilesState {
  Response response;

  MapFilesErrorState({required this.response});
}

class MapFilesBloc extends Bloc<MapFilesEvent, MapFilesState> {
  MapFilesBloc() : super(MapFilesInitState()) {
    on(_onEvent);
  }

  _onEvent(MapFilesEvent event, Emitter<MapFilesState> emit) {
    emit(MapFilesLoadingState());

    // var response = http2.getWithToken(url);
  }
}
