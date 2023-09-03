import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/user.dart';
import 'package:http/http.dart';

class EditRequestFileEvent {
  int request_id;
  int category_id;
  int city_id;
  int minPrice;
  int maxPrice;
  int minMeter;
  int maxMeter;
  int? minRent;
  int? maxRent;
  String title;
  String description;
  List<int> estateIds;

  EditRequestFileEvent({
    required this.request_id,
    required this.category_id,
    required this.city_id,
    required this.minPrice,
    required this.maxPrice,
    required this.minMeter,
    required this.maxMeter,
    this.minRent,
    this.maxRent,
    required this.title,
    required this.description,
    required this.estateIds,
  });

  Map<String, dynamic> toMap() => {
        "category_id": category_id,
        "city_id": city_id,
        "minPrice": minPrice,
        "maxPrice": maxPrice,
        "minMeter": minMeter,
        "maxMeter": maxMeter,
        if (minRent != null) "minRent": minRent,
        if (maxRent != null) "maxRent": maxRent,
        "title": title,
        "description": description,
        "estateIds": estateIds,
      };
}

class EditRequestFileState {}

class EditRequestFileInitState extends EditRequestFileState {}

class EditRequestFileLoadingState extends EditRequestFileState {}

class EditRequestFileSuccessState extends EditRequestFileState {
  Response response;

  EditRequestFileSuccessState({required this.response});
}

class EditRequestFileErrorState extends EditRequestFileState {
  Response? response;

  EditRequestFileErrorState({this.response});
}

class EditRequestFileBloc
    extends Bloc<EditRequestFileEvent, EditRequestFileState> {
  EditRequestFileBloc() : super(EditRequestFileInitState()) {
    on(_onEvent);
  }

  _onEvent(EditRequestFileEvent event, Emitter<EditRequestFileState> emit) async {
    emit(EditRequestFileLoadingState());


    var body = event.toMap();

    Response response = await http2.putJsonWithToken(
      getEstateUrl("estateRequestFile/editRequestFile/${event.request_id}/"),
      body: body,
    );

    if (isResponseOk(response)) {
      emit(EditRequestFileSuccessState(response: response));
    } else {
      emit(EditRequestFileErrorState(response: response));
    }
  }
}
