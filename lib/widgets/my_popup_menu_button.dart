import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';

class MyPopupMenuButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPopupMenuButton();

  List<PopupMenuItem> items;
  Widget? icon;
  String? tooltip;

  MyPopupMenuButton({required this.items, this.icon, this.tooltip});
}

class _MyPopupMenuButton extends State<MyPopupMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: widget.tooltip,
      color: Colors.white,
      icon: widget.icon ?? icon(Icons.more_vert, color: Themes.text),
      elevation: 3,
      constraints: BoxConstraints(minWidth: 180),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      itemBuilder: (context) {
        return widget.items;
      },
    );
  }
}
