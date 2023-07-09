part of 'create_chat_bloc.dart';

@immutable
abstract class CreateChatEvent {}

class CreateChatRequestEvent extends CreateChatEvent {
  int fileConsultantId;

  CreateChatRequestEvent(this.fileConsultantId);
}
