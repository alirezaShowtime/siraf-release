import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';

import 'abstract_message_widget.dart';
import 'date_badge.dart';

class MessageWidgetList {
  List<MapEntry<String, Widget>> _list = [];

  void add({required String createDate, required MessageWidget widget}) {
    // widget.isFirst.add(_list.isEmpty || _list.last is! MessageWidget);

    if (_list.isEmpty || _list.last.key != createDate) {
      _list.add(
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
    _list.add(MapEntry(createDate, widget));

    // if (_list.length > 2) {
    //   if (_list[_list.length - 2].value is MessageWidget) {
    //     (_list[_list.length - 2].value as MessageWidget).isLast.add(false);
    //   }
    // }
    // widget.isLast.add(true);
  }

  List<Widget> getList() {
    List<Widget> newList = [];

    for (MapEntry mapEntry in _list) {
      newList.add(mapEntry.value);
    }
    return newList.reversed.toList();
  }

  void removeAt(int index) {
    _list.removeAt(index);
  }

  void removeWhere(bool Function(MessageWidgetKey) where) {
    _list.removeWhere((e) {
      if (e.value is! MessageWidget) return false;

      return where((e.value as MessageWidget).messageKey);
    });
  }

  Widget get(int index) {
    return _list[index].value;
  }

  int length() {
    return _list.length;
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
}
