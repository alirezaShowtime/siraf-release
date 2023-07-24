part of 'chat_screen_pagination_bloc.dart';

@immutable
abstract class ChatScreenPaginationState {}

class ChatScreenPaginationInitial extends ChatScreenPaginationState {}

class ChatScreenPaginationLoading extends ChatScreenPaginationState {
  ChatScreenPaginationType type;

  ChatScreenPaginationLoading(this.type);
}

class ChatScreenPaginationError extends ChatScreenPaginationState {
  String? message;

  ChatScreenPaginationError(Response? response) {
    if (response != null) {
      message = jDecode(response.body)["message"];
    }
  }
}

class ChatScreenPaginationSuccess extends ChatScreenPaginationState {
  late List<ChatMessage> messages;
  ChatScreenPaginationType type;

  ChatScreenPaginationSuccess(Response res, {required this.type}) {
    messages = ChatMessage.fromList(jDecode(res.body)["data"]["messages"] as List);
  }
}
