part of 'chat_delete_bloc.dart';

@immutable
abstract class ChatDeleteState {}

class ChatDeleteInitial extends ChatDeleteState {}

class ChatDeleteLoading extends ChatDeleteState {}

class ChatDeleteError extends ChatDeleteState {
  String? message;

  ChatDeleteError(Response response) {
    message = jDecode(response.body)["message"];
  }
}

class ChatDeleteSuccess extends ChatDeleteState {
  bool isDeleted;

  ChatDeleteSuccess(this.isDeleted);
}
