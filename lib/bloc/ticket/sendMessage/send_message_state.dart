part of 'send_message_bloc.dart';

@immutable
abstract class SendMessageState {}

class SendMessageInitial extends SendMessageState {}

class SendMessageLoading extends SendMessageState {
  dio.CancelToken cancelToken;
  int count;
  int total;

  SendMessageLoading({required this.count, required this.total, required this.cancelToken});
}

class SendMessageError extends SendMessageState {
  Key key;

  SendMessageError(this.key);
}

class SendMessageSuccess extends SendMessageState {
  Key widgetKey;
  late Message message;

  SendMessageSuccess(this.widgetKey, dio.Response response) {
    message = Message.fromJson(response.data['data']);
  }

  Future<void> playSentSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource("sounds/message-sent.wav"));
  }
}

class SendMessageAddedToQueue extends SendMessageState {}
