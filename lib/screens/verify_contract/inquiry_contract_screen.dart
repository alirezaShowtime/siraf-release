import 'package:flutter/material.dart';
import 'package:siraf3/widgets/block_btn.dart';
import 'package:siraf3/widgets/my_card.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/text_field_2.dart';

class InquiryContractScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InquiryContractScreen();
}

class _InquiryContractScreen extends State<InquiryContractScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.background,
      appBar: SimpleAppBar(titleText: "استعلام قرارداد"),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              children: [
                MyCard(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  title: "شماره قرارداد",
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  child: TextField2(
                    style: TextStyle(fontSize: 14, color: Themes.text),
                    decoration: InputDecoration.collapsed(
                      hintText: "مثال: 21345000976",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
                MyCard(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  title: "تاریخ عقد قرارداد",
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  child: TextField2(
                    style: TextStyle(fontSize: 14, color: Themes.text),
                    decoration: InputDecoration.collapsed(
                      hintText: "مثال: 1401/09/14",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
                MyCard(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  title: "شناسه صنفی دفتر املاک",
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  child: TextField2(
                    style: TextStyle(fontSize: 14, color: Themes.text),
                    decoration: InputDecoration.collapsed(
                      hintText: "مثال: 2241000452",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
                MyCard(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  title: "شماره موبایل یکی از طرفین قرارداد",
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField2(
                        style: TextStyle(fontSize: 14, color: Themes.text),
                        decoration: InputDecoration.collapsed(
                          hintText: "مثال: 09123333333",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: verifyNumberPhone,
                        borderRadius: BorderRadius.circular(20),
                        child: Text(
                          "تایید شماره",
                          style: TextStyle(
                            color: Themes.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
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
            child: BlockBtn(text: "استعلام قرارداد", onTap: () {}),
          ),
        ],
      ),
    );
  }

  void verifyNumberPhone() {}
}
