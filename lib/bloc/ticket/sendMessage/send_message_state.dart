part of 'send_message_bloc.dart';

@immutable
abstract class SendMessageState {}

class SendMessageInitial extends SendMessageState {}

class SendMessageCanceled extends SendMessageState {
  Key widgetKey;

  SendMessageCanceled(this.widgetKey);
}

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
  List<File>? sentFiles;

  SendMessageSuccess(this.widgetKey, dio.Response response, {this.sentFiles}) {
    message = Message.fromJson(response.data['data']["Message"]);

    if (message.fileMessage.isFill() && sentFiles.isFill()) {
      message.fileMessage!.first.uploadedPath = sentFiles!.first.path;
    }
  }

  Future<void> playSentSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource("sounds/message-sent.mp3"));
  }
}

class SendMessageAddedToQueue extends SendMessageState {}
