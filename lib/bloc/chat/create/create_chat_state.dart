part of 'create_chat_bloc.dart';

@immutable
abstract class CreateChatState {}

class CreateChatInitial extends CreateChatState {}

class CreateChatLoading extends CreateChatState {}

class CreateChatError extends CreateChatState {}

class CreateChatSuccess extends CreateChatState {
  late int chatId;
  FileConsultant fileConsultant;
  var file;

  CreateChatSuccess(Response res, {required this.file, required this.fileConsultant}) {
    chatId = jDecode(res.body)["data"]["id"];
  }
}
