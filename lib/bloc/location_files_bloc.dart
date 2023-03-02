import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/models/location_file.dart';

class LocationFilesEvent {
  FilterData filterData;
  String? search;
  LatLng? latLng;

  LocationFilesEvent({required this.filterData, this.search, this.latLng});
}

class LocationFilesState {}

class LocationFilesInitState extends LocationFilesState {}

class LocationFilesLoadingState extends LocationFilesState {}

class LocationFilesLoadedState extends LocationFilesState {
  List<LocationFile> files;

  LocationFilesLoadedState({required this.files});
}

class LocationFilesErrorState extends LocationFilesState {
  Response response;

  LocationFilesErrorState({required this.response});
}

class LocationFilesBloc extends Bloc<LocationFilesEvent, LocationFilesState> {
  LocationFilesBloc() : super(LocationFilesInitState()) {
    on(_onEvent);
  }

  _onEvent(LocationFilesEvent event, Emitter<LocationFilesState> emit) async {
    emit(LocationFilesLoadingState());

    var response = await http2.getWithToken(
      getFileUrl(
        "file/locationFiles" + event.filterData.toQueryString()
            + (event.latLng != null ? "&lat=${event.latLng!.latitude.toString()}&long=${event.latLng!.longitude.toString()}" : "")
            + (event.search != null ? "&q=${event.search!}" : ""),
      ),
    );

    if (isResponseOk(response)) {
      emit(
        LocationFilesLoadedState(
          files: LocationFile.fromList(
            jDecode(response.body),
          ),
        ),
      );
    } else {
      emit(LocationFilesErrorState(response: response));
    }
  }
}
