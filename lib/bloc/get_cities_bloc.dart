import 'package:bloc/bloc.dart';
import 'package:siraf3/models/city.dart';
import 'package:http/http.dart' as http;
import 'package:siraf3/helpers.dart';

class GetCitiesEventBase {}

class GetCitiesEvent extends GetCitiesEventBase {}

class GetCitiesEmitState extends GetCitiesEventBase {
  GetCitiesState state;

  GetCitiesEmitState({required this.state});
}

class GetCitiesState {}

class GetCitiesInitialState extends GetCitiesState {}

class GetCitiesLoadingState extends GetCitiesState {}

class GetCitiesLoadedState extends GetCitiesState {
  List<City> cities;
  bool searching;

  GetCitiesLoadedState({required this.cities, this.searching = false});
}

class GetCitiesErrorState extends GetCitiesState {
  http.Response response;

  GetCitiesErrorState({required this.response});
}

class GetCitiesBloc extends Bloc<GetCitiesEventBase, GetCitiesState> {
  GetCitiesBloc() : super(GetCitiesInitialState()) {
    on(_onEvent);
  }

  _onEvent(event, emit) async {
    if (event is GetCitiesEvent) {
      emit(GetCitiesLoadingState());

      var response = await http.get(getFileUrl("city/citys/"));

      if (response.statusCode == 200) {
        var json = jDecode(response.body);
        var cities = City.fromList(json['data']);
        emit(GetCitiesLoadedState(cities: cities));
      } else {
        emit(GetCitiesErrorState(response: response));
      }
    } else if (event is GetCitiesEmitState) {
      emit(event.state);
    }
  }
}
