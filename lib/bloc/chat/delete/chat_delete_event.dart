part of 'chat_delete_bloc.dart';

@immutable
abstract class ChatDeleteEvent {}

class ChatDeleteRequestEvent extends ChatDeleteEvent {
  List<int> ids;
  bool delete;

  ChatDeleteRequestEvent(this.ids, this.delete);
}
