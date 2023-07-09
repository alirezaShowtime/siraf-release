part of 'chat_list_bloc.dart';

@immutable
abstract class ChatListState {}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListError extends ChatListState {
  String? message;

  ChatListError({Response? response}) {
    if (response != null) {
      message = jDecode(response.body)["message"];
    }
  }
}

class ChatListSuccess extends ChatListState {
  List<ChatItem> chatList = [];

  ChatListSuccess(Response response) {
    print(jDecode(response.body)["data"]);

    chatList = (jDecode(response.body)["data"] as List).map((e) => ChatItem.fromJson(e)).toList();
  }
}
