import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/main.dart';

class MyContentDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyContentDialog();

  String content;

  MyContentDialog({required this.content});
}

class _MyContentDialog extends State<MyContentDialog> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.content,
      style: TextStyle(
        color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
        fontSize: 13,
      ),
    );
  }
}
