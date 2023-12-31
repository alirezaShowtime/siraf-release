import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/models/location_file.dart';
import 'package:siraf3/models/user.dart';

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
  bool search;

  LocationFilesLoadedState({required this.files, this.search = false});
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

    Response response;

    if (await User.hasToken()) {
      response = await http2.getWithToken(
        getFileUrl(
          "file/locationFiles" +
              event.filterData.toQueryString() +
              (event.latLng != null ? "&lat=${event.latLng!.latitude.toString()}&long=${event.latLng!.longitude.toString()}" : "") +
              (event.search != null ? "&q=${event.search!}" : ""),
        ),
        timeout: Duration(seconds: 500),
      );
    } else {
      response = await http2.get(
        getFileUrl(
          "file/locationFiles" +
              event.filterData.toQueryString() +
              (event.latLng != null ? "&lat=${event.latLng!.latitude.toString()}&long=${event.latLng!.longitude.toString()}" : "") +
              (event.search != null ? "&q=${event.search!}" : ""),
        ),
        timeout: Duration(seconds: 500),
      );
    }

    if (isResponseOk(response)) {
      var data = jDecode(response.body)['data'];
      var files = <LocationFile>[];
      if (!(data is String)) {
        files = LocationFile.fromList(data);
      }
      files = files.where((e) => (double.parse(e.lat!) <= 90 && double.parse(e.lat!) >= -90) && (double.parse(e.long!) <= 90 && double.parse(e.long!) >= -90)).toList();
      files = files.unique((e) => e.lat_long);
   
      emit(
        LocationFilesLoadedState(files: files, search: event.search.isFill()),
      );
    } else {
      emit(LocationFilesErrorState(response: response));
    }
  }
}
