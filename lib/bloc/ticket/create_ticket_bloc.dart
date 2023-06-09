import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/group.dart';
import 'package:dio/dio.dart';
import 'package:siraf3/models/user.dart';

class CreateTicketEvent {
  String title;
  String message;
  GroupModel group;

  CreateTicketEvent({required this.title, required this.message, required this.group});
}

class CreateTicketState {}

class CreateTicketInitState extends CreateTicketState {}

class CreateTicketLoadingState extends CreateTicketState {}

class CreateTicketSuccessState extends CreateTicketState {}

class CreateTicketErrorState extends CreateTicketState {
  Response? response;

  CreateTicketErrorState({required this.response});
}

class CreateTicketBloc extends Bloc<CreateTicketEvent, CreateTicketState> {
  CreateTicketBloc() : super(CreateTicketInitState()) {
    on(_onEvent);
  }

  _onEvent(CreateTicketEvent event, Emitter<CreateTicketState> emit) async {
    emit(CreateTicketLoadingState());

    Response? response;
    try {
      var formData = FormData.fromMap({
        "title": event.title,
        "message": event.message,
        "groupId": event.group.id!,
      });

      response = await Dio().post(
        getTicketUrl("ticket/createTicket/").toString(),
        options: Options(
          validateStatus: (status) {
            return true;
          },
          headers: {
            "content-type": "multipart/form-data",
            "Authorization": await User.getBearerToken(),
          },
        ),
        data: formData,
      );
    } on HttpException catch (e) {
      emit(CreateTicketErrorState(response: response));
      return;
    } on SocketException catch (e) {
      emit(CreateTicketErrorState(response: response));
      return;
    } on DioError catch (e) {
      emit(CreateTicketErrorState(response: response));
      return;
    }

    if (response.statusCode == 200) {
      emit(CreateTicketSuccessState());
    } else {
      emit(CreateTicketErrorState(response: response));
    }
  }
}
