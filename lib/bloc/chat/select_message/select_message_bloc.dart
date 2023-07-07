import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SelectMessageEvent {}

class SelectMessageSelectEvent extends SelectMessageEvent {
  Key widgetKey;
  int? messageId;

  SelectMessageSelectEvent(this.widgetKey, this.messageId);
}

class SelectMessageDeselectEvent extends SelectMessageEvent {
  Key widgetKey;

  SelectMessageDeselectEvent(this.widgetKey);
}

abstract class SelectMessageState {}

class SelectMessageSelectState extends SelectMessageState {
  Key widgetKey;
  int? messageId;

  SelectMessageSelectState(this.widgetKey, this.messageId);
}

class SelectMessageDeselectState extends SelectMessageState {
  Key widgetKey;

  SelectMessageDeselectState(this.widgetKey);
}

class SelectMessageBloc extends Bloc<SelectMessageEvent, SelectMessageState?> {
  SelectMessageBloc() : super(null) {
    on<SelectMessageSelectEvent>((event, emit) => emit(SelectMessageSelectState(event.widgetKey, event.messageId)));
    on<SelectMessageDeselectEvent>((event, emit) => emit(SelectMessageDeselectState(event.widgetKey)));
  }
}
