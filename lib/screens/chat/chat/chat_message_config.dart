import 'package:flutter/material.dart';

class ChatMessageConfig {
  late BorderRadius borderRadius;
  Color background;
  Color textColor;
  Color primaryColor;
  Color secondTextColor;
  late TextDirection fileDirection;
  late Alignment alignment;
  Color fileNameColor;

  ChatMessageConfig({
    required double tlRadius,
    required double trRadius,
    required double blRadius,
    required double brRadius,
    required this.background,
    required this.fileNameColor,
    required this.textColor,
    required this.primaryColor,
    required this.secondTextColor,
    required TextDirection textDirection,
  }) {
    borderRadius = BorderRadius.only(
      topLeft: Radius.circular(tlRadius),
      topRight: Radius.circular(trRadius),
      bottomLeft: Radius.circular(blRadius),
      bottomRight: Radius.circular(brRadius),
    );
    fileDirection = textDirection;
    alignment = textDirection == TextDirection.rtl ? Alignment.centerLeft : Alignment.centerRight;
  }
}
