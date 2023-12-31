import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/main.dart';

class MyPopupMenuButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPopupMenuButton();

  List<PopupMenuItem> Function(BuildContext context) itemBuilder;
  void Function(dynamic value)? onSelected;

  IconData? iconData;
  Widget? child;
  Widget? icon;
  String? tooltip;
  dynamic initialValue;

  MyPopupMenuButton({
    required this.itemBuilder,
    this.onSelected,
    this.iconData,
    this.tooltip,
    this.child,
    this.initialValue,
    this.icon,
  });
}

class _MyPopupMenuButton extends State<MyPopupMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      initialValue: widget.initialValue,
      tooltip: widget.tooltip,
      child: widget.child,
      color: Colors.white,
      icon: widget.iconData != null ? Icon(widget.iconData, color: App.theme.textTheme.bodyLarge?.color ?? Themes.text) : widget.icon,
      padding: EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      offset: Offset(10, 10),
      shadowColor: Colors.black54,
      constraints: BoxConstraints(minWidth: 180),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      itemBuilder: widget.itemBuilder,
      onSelected: widget.onSelected,
      onOpened: () {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
