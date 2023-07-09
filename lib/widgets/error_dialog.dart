import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

class ErrorDialog extends StatefulWidget {
  String message;

  ErrorDialog({required this.message, super.key});

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 50, color: Colors.red),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.message,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Themes.text,
                fontSize: 11,
                fontFamily: "IranSansBold",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
