import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_image.dart';

class Empty extends StatelessWidget {
  String? message;

  Empty({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyImage(
            image: AssetImage("assets/images/no-result.png"),
            height: 220,
            width: 220,
          ),
          Text(
            message ?? "نتیجه ای یافت نشد",
            style: TextStyle(
              fontSize: 12,
              color: Themes.text,
              fontFamily: "IranSansBold",
            ),
          ),
        ],
      ),
    );
  }
}
