part of 'chat_delete_message_bloc.dart';

@immutable
abstract class ChatDeleteMessageState {}

class ChatDeleteMessageInitial extends ChatDeleteMessageState {}

class ChatDeleteMessageLoading extends ChatDeleteMessageState {}

class ChatDeleteMessageError extends ChatDeleteMessageState {
  String? message;

  ChatDeleteMessageError(Response? res) {
    if (res != null) {
      message = jDecode(res.body)["message"];
    }
  }
}

class ChatDeleteMessageSuccess extends ChatDeleteMessageState {
  List<int> ids;

  ChatDeleteMessageSuccess(this.ids);
}

class ChatDeleteMessageSending extends ChatDeleteMessageState {
  List<Key> widgetKeys;

  ChatDeleteMessageSending(this.widgetKeys);
}
