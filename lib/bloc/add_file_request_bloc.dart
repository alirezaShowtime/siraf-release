import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/estate.dart';
import 'package:siraf3/models/user.dart';

class AddFileRequestEvent {
  int category_id;
  int city_id;
  int minPrice;
  int maxPrice;
  int minMeter;
  int maxMeter;
  String title;
  String description;
  List<Estate>? estates;

  AddFileRequestEvent({
    required this.category_id,
    required this.city_id,
    required this.minPrice,
    required this.maxPrice,
    required this.minMeter,
    required this.maxMeter,
    required this.title,
    required this.description,
    this.estates,
  });

  Map<String, dynamic> toMap() => {
        "category_id": category_id,
        "city_id": city_id,
        "minPrice": minPrice,
        "maxPrice": maxPrice,
        "minMeter": minMeter,
        "maxMeter": maxMeter,
        "title": title,
        "description": description,
        if (estates != null)
          "estateIds": estates!.map<int>((e) => e.id!).toList(),
      };
}

class AddFileRequestState {}

class AddFileRequestInitState extends AddFileRequestState {}

class AddFileRequestLoadingState extends AddFileRequestState {}

class AddFileRequestSuccessState extends AddFileRequestState {
  Response response;

  AddFileRequestSuccessState({required this.response});
}

class AddFileRequestErrorState extends AddFileRequestState {
  Response? response;

  AddFileRequestErrorState({this.response});
}

class AddFileRequestBloc
    extends Bloc<AddFileRequestEvent, AddFileRequestState> {
  AddFileRequestBloc() : super(AddFileRequestInitState()) {
    on(_onEvent);
  }

  _onEvent(AddFileRequestEvent event, Emitter<AddFileRequestState> emit) async {
    emit(AddFileRequestLoadingState());

    Response? response;

    try {
      response = await http2.postJsonWithToken(
        getEstateUrl("fileRequest/addFileRequest/"),
        body: event.toMap(),
      );
    } on HttpException catch (_) {
      return emit(AddFileRequestErrorState(response: response));
    } on SocketException catch (_) {
      return emit(AddFileRequestErrorState(response: response));
    } on ClientException catch (_) {
      return emit(AddFileRequestErrorState(response: response));
    }

    if (isResponseOk(response)) {
      emit(AddFileRequestSuccessState(response: response));
    } else {
      emit(AddFileRequestErrorState(response: response));
    }
  }
}
