part of 'chat_block_bloc.dart';

@immutable
abstract class ChatBlockState {}

class ChatBlockInitial extends ChatBlockState {}

class ChatBlockLoading extends ChatBlockState {}

class ChatBlockError extends ChatBlockState {
  String? message;

  ChatBlockError(Response response) {
    if (jDecode(response.body) is Map && (jDecode(response.body) as Map<String, dynamic>).containsKey("message")) {
      message = jDecode(response.body)["message"];
    }
  }
}

class ChatBlockSuccess extends ChatBlockState {
  bool isBlock;

  ChatBlockSuccess(this.isBlock);
}
