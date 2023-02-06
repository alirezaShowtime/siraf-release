import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class MyCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyCard();

  Widget child;
  String title;
  EdgeInsets? padding;
  EdgeInsets? margin;

  MyCard({required this.child, required this.title, this.padding, this.margin});
}

class _MyCard extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: widget.margin ?? EdgeInsets.only(top: 8),
            padding: widget.padding ??
                EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: widget.child,
          ),
          Positioned(
            top: 0,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              color: Themes.background,
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 12,
                  color: Themes.textGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
