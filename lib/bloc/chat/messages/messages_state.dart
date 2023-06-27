part of 'messages_bloc.dart';

@immutable
abstract class MessagesState {}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesSuccess extends MessagesState {
  late List<ChatMessage> messages;

  Response response;

  MessagesSuccess({required this.response}) {
    var data = jDecode(response.body)["data"];

    messages = ChatMessage.fromList(data);

    for (int i = 0; i < messages.length; i++) {
      ChatMessage message = messages[i];

      if (!message.message.isFill() && !message.fileMessages.isFill()) {
        messages.remove(message);
      }
      try {
        var reply = messages.singleWhere((e) => e.id == message.replyId);

        message.replyMessage = reply;
        messages[i] = message;
      } catch (e) {}
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
