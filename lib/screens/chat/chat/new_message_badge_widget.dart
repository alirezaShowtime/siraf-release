import 'package:flutter/material.dart';
import 'package:siraf3/main.dart';

class NewMessageBadgeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: App.theme.primaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "پیام جدید",
            style: TextStyle(color: Colors.white, fontSize: 9, fontFamily: "IranSansMedium"),
          ),
          Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
        ],
      ),
    );
  }
}
