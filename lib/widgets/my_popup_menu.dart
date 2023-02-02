import 'package:flutter/material.dart';

class MyPopupMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPopupMenu();

  List<PopupMenuItem> items;

  Widget icon;

  String? tooltip;

  MyPopupMenu({
    required this.items,
    required this.icon,
    this.tooltip,
  });
}

class _MyPopupMenu extends State<MyPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      elevation: 12,
      offset: Offset(0, 50),
      shadowColor: Colors.black38,
      icon: widget.icon,
      tooltip: widget.tooltip,
      itemBuilder: (context) {
        return widget.items.map((item) {
          (item.child as Text).style!.merge(TextStyle(fontSize: 13));
          return item;
        }).toList();
      },
    );
  }
}
