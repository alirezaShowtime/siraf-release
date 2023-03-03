import 'package:flutter/material.dart';

import '../themes.dart';

class BlockBtn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BlockBtn();

  String text;
  Function() onTap;
  EdgeInsets? padding;

  BlockBtn({required this.text, required this.onTap, this.padding});
}

class _BlockBtn extends State<BlockBtn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(10),
      child: MaterialButton(
        minWidth: double.infinity,
        onPressed: widget.onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        height: 50,
        color: Themes.blue,
        textColor: Colors.white,
        elevation: 0,
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
