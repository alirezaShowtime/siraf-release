import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class DateBadge extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DateBadge();

  String title;
  void Function()? onTap;
  Color color;
  EdgeInsetsGeometry? margin;

  DateBadge({required this.title, this.onTap, this.color = Colors.white, this.margin});
}

class _DateBadge extends State<DateBadge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      alignment: Alignment.topCenter,
      child: Material(
        color: widget.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            constraints: BoxConstraints(
              minWidth: 50,
            ),
            child: Text(
              widget.title,
              style: TextStyle(
                color: Themes.text,
                fontWeight: FontWeight.w500,
                fontSize: 10,
                fontFamily: "IranSansBold",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
