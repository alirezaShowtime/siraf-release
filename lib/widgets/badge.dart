import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class Badge extends StatefulWidget {
  @override
  State<Badge> createState() => _Badge();

  String text;

  Badge({required this.text});
}

class _Badge extends State<Badge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      margin: EdgeInsets.symmetric(horizontal: 3),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Themes.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
      child: Text(
        widget.text + "890",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Themes.primary,
          fontSize: 11,
        ),
      ),
    );
  }
}
