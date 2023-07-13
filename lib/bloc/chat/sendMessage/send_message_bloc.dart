import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:siraf3/controller/chat_message_upload_controller.dart';
import 'package:siraf3/enums/message_state.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/http2.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/models/user.dart';

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
        chatId: event.chatId,
        controller: event.controller,
        files: await event.getFiles(),
        files2: event.files,
        message: event.message,
        replyMessage: event.replyMessage,
        widgetKey: event.widgetKey,
      ),
    );

    _executeQueue(startFrom);

    emit(SendMessageAddedToQueue());
  }

  FutureOr<void> _request(SendMessageRequestEvent event, Emitter<SendMessageState> emit) async {
    dio.CancelToken cancelToken = dio.CancelToken();
    event.requestModel.controller.setOnCancelUpload(cancelToken.cancel);

    var url = "https://chat.siraf.app/api/message/addMessageUser/";

    dio.FormData formData = dio.FormData.fromMap({
      "chatId": event.requestModel.chatId,
      "message": event.requestModel.message,
      if (event.requestModel.replyMessage?.id != null) "replyId": event.requestModel.replyMessage!.id!,
    });

    dio.Options options = dio.Options(
      validateStatus: (_) => true,
      headers: {
        "Content-type": "multipart/form-data",
        "Authorization": await User.getBearerToken(),
      },
    );

    cancelToken.whenCancel.then((value) => emit(SendMessageCanceled(event.requestModel.widgetKey)));

    if (event.requestModel.files != null) {
      formData.files.addAll(event.requestModel.files!);
    }

    try {
      event.requestModel.controller.messageSate.add(MessageState.Uploading);

      var res = await dio.Dio().post(
        url,
        options: options,
        data: formData,
        onSendProgress: (int now, int count) => event.requestModel.controller.uploading.add(UploadingDetail(now, count)),
        cancelToken: cancelToken,
      );

      logRequestDio(res);

      if (res.statusCode != 200 || res.data["status"] != 1) {
        throw new Exception();
      }

      event.requestModel.controller.messageSate.add(MessageState.Uploaded);

      emit(SendMessageSuccess(
        event.requestModel.widgetKey,
        res,
        sentFiles: event.requestModel.files2,
        replyMessage: event.requestModel.replyMessage,
      ));
    } catch (e) {
      event.requestModel.controller.messageSate.add(MessageState.ErrorUpload);
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
