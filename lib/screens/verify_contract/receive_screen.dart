import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/block_btn.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_card.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';

class ReceiveScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReceiveScreen();
}

class _ReceiveScreen extends State<ReceiveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.background,
      appBar: SimpleAppBar(titleText: "دریافت قرارداد"),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 12, right: 12),
            child: Column(
              children: [
                MyCard(
                  title: "مشخصات قرارداد",
                  child: Column(
                    children: [
                      //todo: This information is tentative
                      _item("نوع قرارداد", "مبایعه نامه"),
                      _item("شماره قرارداد", "842945345"),
                      _item("تاریخ عقد قرارداد", "1401/08/12"),
                      _item("شناسه صنفی دفتر املاک", "200043434"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BlockBtn(text: "دریافت قرارداد", onTap: () {}),
          ),
        ],
      ),
    );
  }

  Widget _item(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${key}:",
            style: TextStyle(
              fontSize: 11,
              color: Themes.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              color: Themes.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
