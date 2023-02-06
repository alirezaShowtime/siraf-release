import 'package:flutter/material.dart';

class MyAlertDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAlertDialog();

  Widget title;
  Widget content;
  List<Widget>? actions;

  MyAlertDialog({
    required this.title,
    required this.content,
    this.actions,
  });
}

class _MyAlertDialog extends State<MyAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 3,
      actionsAlignment: MainAxisAlignment.start,
      title: widget.title,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: widget.content,
      actions: widget.actions,
    );
  }
}
