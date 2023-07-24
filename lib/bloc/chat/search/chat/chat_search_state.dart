part of 'chat_search_bloc.dart';

@immutable
abstract class ChatSearchState {}

class ChatSearchInitial extends ChatSearchState {}

class ChatSearchLoading extends ChatSearchState {}

class ChatSearchCancel extends ChatSearchState {}

class ChatSearchError extends ChatSearchState {
  String? message;

  ChatSearchError(Response res) {
    message = jDecode(res.body)["message"];
  }
}

class ChatSearchSuccess extends ChatSearchState {
  late List<ChatItem> chatItems;

  ChatSearchSuccess(Response res) {
    var data = jDecode(res.body)["data"];

    for (Map msg in data) {
      chatItems.add(ChatItem.fromJson(msg));
    }
  }
}
