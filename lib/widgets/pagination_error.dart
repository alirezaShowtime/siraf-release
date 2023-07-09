import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_text_button.dart';

class PaginationError extends StatelessWidget {
  void Function()? onClickTryAgain;

  PaginationError({this.onClickTryAgain});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.grey.shade200,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, color: Themes.text, size: 20),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              "خطایی در هنگام بارگذاری رخ داد",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 10, fontFamily: "IranSansBold"),
            ),
          ),
          if (onClickTryAgain != null)
            MyTextButton(
              text: "تلاش مجدد",
              fontSize: 10,
              onPressed: onClickTryAgain,
            ),
        ],
      ),
    );
  }
}
