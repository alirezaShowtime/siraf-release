import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/city.dart';

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
  String? message;

  GetCitiesErrorState(Response response) {
    message = jDecode(response.body)["message"];
  }
}

class GetCitiesBloc extends Bloc<GetCitiesEventBase, GetCitiesState> {
  GetCitiesBloc() : super(GetCitiesInitialState()) {
    on(_onEvent);
  }

  _onEvent(event, emit) async {
    if (event is GetCitiesEmitState) {
      return emit(event.state);
    }

    if (event is! GetCitiesEvent) return;

    emit(GetCitiesLoadingState());

    var res = await http2.get(getFileUrl("city/citys/"));

    if (res.statusCode != 200) {
      return emit(GetCitiesErrorState(res));
    }
    var cities = City.fromList(jDecode(res.body)['data']);
    return emit(GetCitiesLoadedState(cities: cities));
  }
}
