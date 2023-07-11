import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class MyListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyListView();

  ListView listView;
  bool isEmpty;
  String emptyText;

  MyListView({required this.isEmpty, required this.listView, this.emptyText = "لیست خالی است"});
}

class _MyListView extends State<MyListView> {
  @override
  Widget build(BuildContext context) {
    return widget.isEmpty ? empty(context) : widget.listView;
  }

  Widget empty(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 160,
        maxWidth: 160,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/no-result.png"),
          Text(
            widget.emptyText,
            style: TextStyle(color: Themes.text, fontSize: 11, fontFamily: "IranSansBold"),
          ),
        ],
      ),
    );
  }
}