import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/models/user.dart';

class EditProfileEvent {
  String? name;
  String? bio;
  FileImage? avatar;
  bool? mobilePrivate;

  EditProfileEvent({this.name, this.bio, this.avatar, this.mobilePrivate});
}

class EditProfileState {}

class EditProfileInitState extends EditProfileState {}

class EditProfileLoadingState extends EditProfileState {}

class EditProfileSuccessState extends EditProfileState {
  String? name;
  String? bio;
  String? avatar;

  EditProfileSuccessState({this.name, this.bio, this.avatar});
}

class EditProfileErrorState extends EditProfileState {
  String message;

  EditProfileErrorState({required this.message});
}

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitState()) {
    on(_onEvent);
  }

  _onEvent(EditProfileEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoadingState());

    Response? response;

    var message = "خطا هنگام ارسال اطلاعات رخ داد";

    try {
      var headers = {
        "content-type": "multipart/form-data",
        "Authorization": await User.getBearerToken(),
      };

      var formData = FormData.fromMap({
        if (event.name != null) 'name': event.name,
        if (event.bio != null) 'bio': event.bio,
        if (event.mobilePrivate != null) 'mobilePrivate': event.mobilePrivate,
      });

      formData.files.addAll([
        if (event.avatar != null)
          MapEntry(
              "avatar", await MultipartFile.fromFile(event.avatar!.file.path)),
      ]);

      response = await Dio().post(
        "https://auth.siraf.app/api/user/userEdit/",
        options: Options(
          validateStatus: (status) {
            return true;
          },
          headers: headers,
        ),
        data: formData,
      );
      
      print(response.statusCode);
      print(response.data);

    } on HttpException catch (_) {
      emit(EditProfileErrorState(message: message));
      return;
    } on SocketException catch (_) {
      emit(EditProfileErrorState(message: message));
      return;
    } on DioError catch (_) {
      emit(EditProfileErrorState(message: message));
      return;
    }

    if (response.statusCode! >= 400) {
      message = response.data['message'] as String? ?? "خطایی در سرور رخ داد";
      emit(EditProfileErrorState(message: message));
    }

    emit(EditProfileSuccessState(
      name: response.data['data']['name'],
      bio: response.data['data']['bio'],
      avatar: response.data['data']['avatar'],
    ));
  }
}
