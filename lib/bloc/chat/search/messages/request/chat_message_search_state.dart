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
  int? countSearch;
  MessageSearchType? type;

  ChatMessageSearchSuccess(Response response, {required this.searched, this.type}) {
    Map data = jDecode(response.body)["data"];
    messages = ChatMessage.fromList(data["messages"]);

    if (data.containsKey("countSearch")) {
      countSearch = data["countSearch"];
    }
  }
}
