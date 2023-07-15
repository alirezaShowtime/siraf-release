part of 'chat_block_bloc.dart';

@immutable
abstract class ChatBlockEvent {}

class ChatBlockRequestEvent extends ChatBlockEvent {
  List<int> ids;
  bool block;

  ChatBlockRequestEvent(this.ids, this.block);
}
