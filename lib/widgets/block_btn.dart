import 'package:flutter/material.dart';

import '../themes.dart';

class BlockBtn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BlockBtn();

  String text;
  GestureTapCallback onTap;

  BlockBtn({required this.text, required this.onTap});
}

class _BlockBtn extends State<BlockBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 60,
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Themes.blue,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
