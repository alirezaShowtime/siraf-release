import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart' as dio;
import 'package:siraf3/controller/message_upload_controller.dart';
import 'package:siraf3/models/ticket_details.dart';
import 'package:siraf3/models/user.dart';
import 'package:flutter/material.dart';

part 'send_message_event.dart';
part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  List<SendMessageRequestModel> _requestQueue = [];

  SendMessageBloc() : super(SendMessageInitial()) {
    on<AddToSendQueueEvent>(_addToQueue);
    on<SendMessageRequestEvent>(_request);
  }

  FutureOr<void> _addToQueue(AddToSendQueueEvent event, Emitter<SendMessageState> emit) async {
    var startFrom = _requestQueue.length;
    _requestQueue.add(
      SendMessageRequestModel(
        ticketId: event.ticketId,
        controller: event.controller,
        files: await event.getFiles(),
        message: event.message,
        widgetKey: event.widgetKey,
      ),
    );

    _executeQueue(startFrom);

    emit(SendMessageAddedToQueue());
  }

  FutureOr<void> _request(SendMessageRequestEvent event, Emitter<SendMessageState> emit) async {
    dio.CancelToken cancelToken = dio.CancelToken();
    event.requestModel.controller.setOnCancelUpload(cancelToken.cancel);

    var url = "https://ticket.siraf.app/api/ticket/addMessage/";

    dio.FormData formData = dio.FormData.fromMap({
      "ticketId": event.requestModel.ticketId,
      "message": event.requestModel.message,
    });

    dio.Options options = dio.Options(
      validateStatus: (_) => true,
      headers: {
        "Content-type": "multipart/form-data",
        "Authorization": await User.getBearerToken(),
      },
    );

    if (event.requestModel.files != null) {
      formData.files.addAll(event.requestModel.files!);
    }

    try {
      var res = await dio.Dio().post(
        url,
        options: options,
        data: formData,
        onSendProgress: event.requestModel.controller.uploading,
        cancelToken: cancelToken,
      );

      if (res.statusCode != 200 || res.data["status"] != 1) {
        throw new Exception();
      }

      event.requestModel.controller.uploaded();

      emit(SendMessageSuccess(event.requestModel.widgetKey,res));
    } catch (e) {
      event.requestModel.controller.errorUpload();
      emit(SendMessageError(event.requestModel.widgetKey));
    }
  }

  Future<void> _executeQueue(int startFrom) async {
    if (_requestQueue.isEmpty) return;
    for (var i = startFrom; i < _requestQueue.length; i++) {
      add(SendMessageRequestEvent(_requestQueue[i]));
      _requestQueue.remove(_requestQueue[i]);
    }
  }
}
