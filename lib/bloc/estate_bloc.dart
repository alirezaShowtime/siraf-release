import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/estate.dart';

class EstateEvent {}

class EstateLoadEvent extends EstateEvent {
  List<int> city_ids;
  String? search;

  EstateLoadEvent({required this.city_ids, this.search});
}

class EstateState {}

class EstateInitState extends EstateState {}

class EstateLoadingState extends EstateState {}

class EstateLoadedState extends EstateState {
  List<Estate> estates;

  EstateLoadedState({required this.estates});
}

class EstateErrorState extends EstateState {
  Response? response;

  EstateErrorState({required this.response});
}

class EstateBloc extends Bloc<EstateEvent, EstateState> {
  EstateBloc() : super(EstateInitState()) {
    on(_onEvent);
  }

  _onEvent(event, emit) async {
    event = event as EstateLoadEvent;
    emit(EstateLoadingState());

    Response response;

    print(getEstateUrl("estate/estates?city_id=" +
            jsonEncode(event.city_ids.toList()) +
            "&name=" +
            (event.search ?? ""))
        .toString());

    print(jsonEncode(event.city_ids.toList()));

    try {
      response = await get(getEstateUrl("estate/estates?city_id=" +
          jsonEncode(event.city_ids.toList()) +
          "&name=" +
          (event.search ?? "")));
    } on HttpException catch (e) {
      emit(EstateErrorState(response: null));
      return;
    } on SocketException catch (e) {
      emit(EstateErrorState(response: null));
      return;
    }

    if (isResponseOk(response)) {
      var json = jDecode(response.body);

      emit(EstateLoadedState(estates: Estate.fromList(json['data'])));
    } else {
      emit(EstateErrorState(response: response));
    }
  }
}
