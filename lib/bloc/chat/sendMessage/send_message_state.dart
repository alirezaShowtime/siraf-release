part of 'send_message_bloc.dart';

@immutable
abstract class SendMessageState {}

class SendMessageInitial extends SendMessageState {}

class SendMessageForbiddenAccess extends SendMessageState {}

class SendMessageCanceled extends SendMessageState {
  List<Key> widgetKeys;

  SendMessageCanceled(this.widgetKeys);
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
  late ChatMessage message;
  ChatMessage? replyMessage;
  List<File>? sentFiles;

  SendMessageSuccess(this.widgetKey, dio.Response response, {this.sentFiles, this.replyMessage}) {
    message = ChatMessage.fromJson(response.data['data']);

    message.replyId = replyMessage?.id;
    message.reply = replyMessage;

    if (message.fileMessages.isFill() && sentFiles.isFill()) {
      message.fileMessages!.first.uploadedPath = sentFiles!.first.path;
    }
  }

  Future<void> playSentSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource("sounds/message-sent.wav"));
  }
}

class SendMessageAddedToQueue extends SendMessageState {}
