part of 'chat_block_bloc.dart';

@immutable
abstract class ChatBlockState {}

class ChatBlockInitial extends ChatBlockState {}

class ChatBlockLoading extends ChatBlockState {}

class ChatBlockError extends ChatBlockState {
  String? message;

  ChatBlockError(Response response) {
    message = jDecode(response.body)["message"];
  }
}

class ChatBlockSuccess extends ChatBlockState {
  bool isBlock;

  ChatBlockSuccess(this.isBlock);
}
