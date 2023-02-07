import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/estate.dart';

class EstateEvent {}

class EstateLoadEvent extends EstateEvent {
  List<int> city_ids;
  String? search;
  String? sort;

  EstateLoadEvent({required this.city_ids, this.search, this.sort});
}

class EstateState {}

class EstateInitState extends EstateState {}

class EstateLoadingState extends EstateState {}

class EstateLoadedState extends EstateState {
  List<Estate> estates;
  String? sort_type;

  EstateLoadedState({required this.estates, this.sort_type});
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

    try {
      var url = getEstateUrl(
        "estate/estates?city_id=" +
            jsonEncode(event.city_ids.toList()) +
            "&name=" +
            (event.sort != null ? "&sort=" + event.sort! : ""),
      );

      print(url.toString());

      response = await http2.get(url);
    } on HttpException catch (e) {
      emit(EstateErrorState(response: null));
      return;
    } on SocketException catch (e) {
      emit(EstateErrorState(response: null));
      return;
    }

    if (isResponseOk(response)) {
      var json = jDecode(response.body);

      emit(EstateLoadedState(estates: Estate.fromList(json['data']['estats']), sort_type: event.sort));
    } else {
      emit(EstateErrorState(response: response));
    }
  }
}
