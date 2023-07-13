part of 'create_chat_bloc.dart';

@immutable
abstract class CreateChatEvent {}

class CreateChatRequestEvent extends CreateChatEvent {
  FileConsultant fileConsultant;
  FileDetail file;

  CreateChatRequestEvent({
    required this.fileConsultant,
    required this.file,
  });
}
