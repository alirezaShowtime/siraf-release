import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/chat_message.dart';

import 'abstract_message_widget.dart';
import 'date_badge.dart';
import 'messageWidgets/chat_message_widget.dart';

class MessageWidgetList {
  List<MapEntry<String, Widget>> _list = [];

  MessageWidget? lastMessageWidget() {
    for (var i = _list.length - 1; i >= 0; i--) {
      if (_list[i].value is MessageWidget) return _list[i].value as MessageWidget;
    }
    return null;
  }

  MessageWidget? firstMessageWidget() {
    for (var i = 0; i < _list.length; i++) {
      if (_list[i].value is MessageWidget) return _list[i].value as MessageWidget;
    }
    return null;
  }

  List<int> indexesWhere(bool Function(MessageWidget) where) {
    List<int> indexes = [];

    try {
      var list = _list.where((e) => e is MessageWidget && where(e.value as MessageWidget));
      for (var item in list) indexes.add(_list.indexOf(item));
    } catch (e) {
      throw e;
    }

    return indexes;
  }

  void shift({required String createDate, required MessageWidget widget}) {
    if (_list.isNotEmpty && _list.first.key == createDate && _list.first.value is DateBadge) {
      _list.removeAt(0);
    }

    _list.insert(0, MapEntry(createDate, widget));
    _list.insert(
      0,
      MapEntry(
        createDate,
        DateBadge(
          createDate: dateFormatter(createDate),
          color: Colors.grey.shade100,
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  void add({required String createDate, required MessageWidget widget}) {
    if (_list.isEmpty || _list.last.key != createDate) {
      var w = MapEntry(
        createDate,
        DateBadge(
          createDate: dateFormatter(createDate),
          color: Colors.grey.shade100,
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
      );

      _list.add(w);
    }
    _list.add(MapEntry(createDate, widget));
  }

  List<Widget> getList() {
    if (_list.isNotEmpty && _list.last.value is! MessageWidget) {
      _list.removeLast();
    }

    List<Widget> newList = [for (MapEntry e in _list) e.value];
    return newList.toList();
  }

  void removeAt(int index) {
    _list.removeAt(index);
    onRemovedMessage();
  }

  void removeWhere(bool Function(MessageWidgetKey) where) {
    _list.removeWhere((e) {
      if (e.value is! MessageWidget) return false;

      return where((e.value as MessageWidget).messageKey);
    });
    onRemovedMessage();
  }

  Widget get(int index) {
    return _list[index].value;
  }

  int length() {
    return _list.length;
  }

  int widgetLength() {
    return _list.where((e) => e.value is MessageWidget).length;
  }

  void replace(int i, Widget newWidget) {
    _list[i] = MapEntry(_list[i].key, newWidget);
  }

  int indexByKey(Key key) {
    return _list.indexWhere((e) => e.value.key == key);
  }

  int indexOfCreateDate(createDate) {
    return _list.indexOf(createDate);
  }

  void clearList() {
    _list.clear();
  }

  void onRemovedMessage() {
    if (length() > 0 && widgetLength() == 0) {
      _list.clear();
    }
  }

  void fromChatMessages(List<ChatMessage> chatMessages, {void Function(ChatMessage? replyMessage)? onClickReplyMessage}) {
    for (ChatMessage chatMessage in chatMessages) {
      _list.add(
        MapEntry(
          chatMessage.createDate!,
          ChatMessageWidget(
            message: chatMessage,
            messageKey: MessageWidgetKey(chatMessage),
            onClickReplyMessage: onClickReplyMessage,
          ),
        ),
      );
    }
  }
}
