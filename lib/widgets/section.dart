import 'package:flutter/material.dart';

import 'package:siraf3/main.dart';
import '../themes.dart';

class Section extends StatefulWidget {
  @override
  State<Section> createState() => _Section();

  String title;
  String hint;
  String? value;
  Function() onTap;

  Section({
    required this.title,
    required this.hint,
    this.value,
    required this.onTap,
  });
}

class _Section extends State<Section> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: (App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey).withOpacity(0.5), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 13,
              fontFamily: "IranSansMedium",
            ),
          ),
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              constraints: BoxConstraints(
                minWidth: 30,
              ),
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: Text(
                widget.value ?? widget.hint,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "IranSansMedium",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
