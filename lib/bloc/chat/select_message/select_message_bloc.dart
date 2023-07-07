import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SelectMessageEvent {}

class SelectMessageCountEvent extends SelectMessageEvent {
  int count;

  SelectMessageCountEvent(this.count);
}

class SelectMessageDeselectAllEvent extends SelectMessageEvent {}

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

class SelectMessageDeselectAllState extends SelectMessageState {}

class SelectMessageCountSate extends SelectMessageState {
  int count;

  SelectMessageCountSate(this.count);
}

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
    on<SelectMessageDeselectAllEvent>((event, emit) => emit(SelectMessageDeselectAllState()));
    on<SelectMessageCountEvent>((event, emit) => emit(SelectMessageCountSate(event.count)));
  }
}
