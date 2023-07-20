part of 'chat_message_search_bloc.dart';

@immutable
abstract class ChatMessageSearchState {}

class ChatMessageSearchInitial extends ChatMessageSearchState {}

class ChatMessageSearchCancel extends ChatMessageSearchState {}

class ChatMessageSearchLoading extends ChatMessageSearchState {}

class ChatMessageSearchError extends ChatMessageSearchState {
  String? message;

  ChatMessageSearchError(Response response) {
    message = jDecode(response.body)["message"];
  }
}

class ChatMessageSearchSuccess extends ChatMessageSearchState {
  late List<ChatMessage> messages;
  String searched;
  late int countSearch;

  ChatMessageSearchSuccess(Response response, {required this.searched}) {
    var data = jDecode(response.body)["data"];
    messages = ChatMessage.fromList(data["messages"]);
    countSearch = data["countSearch"];
  }
}
