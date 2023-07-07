part of 'create_chat_bloc.dart';

@immutable
abstract class CreateChatState {}

class CreateChatInitial extends CreateChatState {}

class CreateChatLoading extends CreateChatState {}

class CreateChatError extends CreateChatState {}

class CreateChatSuccess extends CreateChatState {}
