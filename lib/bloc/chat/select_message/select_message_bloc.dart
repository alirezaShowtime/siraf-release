import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SelectMessageEvent {}

class SelectMessageCountEvent extends SelectMessageEvent {
  int count;

  SelectMessageCountEvent(this.count);
}

class SelectMessageClearEvent extends SelectMessageEvent {}

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

class SelectMessageClearState extends SelectMessageState {}

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
  List<MapEntry<Key, int?>> selectedMessages = [];

  SelectMessageBloc() : super(null) {
    on<SelectMessageSelectEvent>(_select);
    on<SelectMessageDeselectEvent>(_deselect);
    on<SelectMessageClearEvent>(_clear);
    on<SelectMessageCountEvent>((event, emit) => emit(SelectMessageCountSate(selectedMessages.length)));
  }

  _select(event, emit) {
    selectedMessages.add(MapEntry(event.widgetKey, event.messageId));
    add(SelectMessageCountEvent(selectedMessages.length));
    return emit(SelectMessageSelectState(event.widgetKey, event.messageId));
  }

  _deselect(event, emit) {
    selectedMessages.removeWhere((e) => e.key == event.widgetKey);
    add(SelectMessageCountEvent(selectedMessages.length));
    return emit(SelectMessageDeselectState(event.widgetKey));
  }

  _clear(event, emit) {
    selectedMessages.clear();
    add(SelectMessageCountEvent(selectedMessages.length));
    return emit(SelectMessageClearState());
  }
}
