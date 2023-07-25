part of 'messages_bloc.dart';

@immutable
abstract class MessagesState {}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesSuccess extends MessagesState {
  List<ChatMessage> messages = [];
  int newMessageCount = 0;

  Response response;

  MessagesSuccess({required this.response}) {
    try {
      var data = jDecode(response.body)["data"];
      messages = ChatMessage.fromList(data["messages"]);
      messages = messages.reversed.toList();
      newMessageCount = data["chat"]["message"]["countNotSeen"];
    } catch (e) {
      return;
    }
  }
}

class MessagesError extends MessagesState {
  Response response;

  String? message;

  MessagesError({required this.response}) {
    message = jDecode(response.body)['message'] as String?;
  }
}
