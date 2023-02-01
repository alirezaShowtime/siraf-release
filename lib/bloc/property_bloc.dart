import 'dart:io';

import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/property_insert.dart';

class PropertyEvent {}

class PropertyInsertEvent extends PropertyEvent {
  int? category_id;
  String type;

  PropertyInsertEvent({required this.category_id, this.type = "insert"});
}

class PropertyFilterEvent extends PropertyEvent {}

class PropertyState {}

class PropertyInitState extends PropertyState {}

class PropertyLoadingState extends PropertyState {}

class PropertyLoadedState extends PropertyState {
  List<PropertyInsert> iproperties;

  PropertyLoadedState({required this.iproperties});
}

class PropertyErrorState extends PropertyState {
  Response? response;

  PropertyErrorState({this.response});
}

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  PropertyBloc() : super(PropertyInitState()) {
    on(_onEvent);
  }

  _onEvent(PropertyEvent event, emit) async {
    emit(PropertyLoadingState());

    if (event is PropertyInsertEvent) {
      if (event.category_id == null) {
        emit(PropertyLoadedState(iproperties: []));
        return;
      }

      Response response;

      try {
        response = await get(getFileUrl(
            "property/propertyFields?catId=${event.category_id}&type=${event.type}"));
      } on HttpException catch (e) {
        emit(PropertyErrorState());
        return;
      } on SocketException catch (e) {
        emit(PropertyErrorState());
        return;
      }

      if (isResponseOk(response)) {
        var json = jDecode(response.body);

        emit(PropertyLoadedState(
            iproperties: PropertyInsert.fromList(json['data'])));
      } else {
        emit(PropertyErrorState(response: response));
      }
    }
  }
}
