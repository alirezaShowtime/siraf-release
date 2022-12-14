import 'package:bloc/bloc.dart';
import 'package:siraf3/models/city.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetCitiesEvent {}

class GetCitiesState {}

class GetCitiesInitialState extends GetCitiesState {}

class GetCitiesLoadingState extends GetCitiesState {}

class GetCitiesLoadedState extends GetCitiesState {
  List<City> cities;

  GetCitiesLoadedState({required this.cities});
}

class GetCitiesErrorState extends GetCitiesState {
  http.Response response;

  GetCitiesErrorState({required this.response});
}

class GetCitiesBloc extends Bloc<GetCitiesEvent, GetCitiesState> {
  GetCitiesBloc() : super(GetCitiesInitialState()) {
    on(_onEvent);
  }

  _onEvent(event, emit) async {
    emit(GetCitiesLoadingState());

    var response =
        await http.get(Uri.http("188.121.106.229:8001/api/city/citys/"));

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var cities = City.fromList(json['data']);
      emit(GetCitiesLoadedState(cities: cities));
    } else {
      emit(GetCitiesErrorState(response: response));
    }
  }
}
