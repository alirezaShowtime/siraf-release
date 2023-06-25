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

    messages = _removeEmptyMessage(ChatMessage.fromList(data));
  }

  List<ChatMessage> _removeEmptyMessage(List<ChatMessage> messages) {
    List<ChatMessage> newList = [];

    for (ChatMessage message in messages) {
      if (!message.message.isFill() && !message.fileMessages.isFill()) continue;
      newList.add(message);
    }

    return newList;
  }
}

class MessagesError extends MessagesState {
  Response response;

  String? message;

  MessagesError({required this.response}) {
    message = jDecode(response.body)['message'] as String?;
  }
}
