part of 'seen_message_bloc.dart';

@immutable
abstract class SeenMessageState {}

class SeenMessageInitial extends SeenMessageState {}

class SeenMessageError extends SeenMessageState {}

class SeenMessageSuccess extends SeenMessageState {}
