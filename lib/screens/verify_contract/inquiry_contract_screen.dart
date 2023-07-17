import 'package:flutter/material.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/block_btn.dart';
import 'package:siraf3/widgets/my_card.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';
import 'package:siraf3/widgets/text_field_2.dart';

class InquiryContractScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InquiryContractScreen();
}

class _InquiryContractScreen extends State<InquiryContractScreen> {
  TextEditingController contractNumberController = TextEditingController();
  TextEditingController contractDateController = TextEditingController();
  TextEditingController officeConsultantIdController = TextEditingController();
  TextEditingController numberPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(titleText: "استعلام قرارداد"),
      body: Stack(
        fit: StackFit.expand,
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
                    controller: contractNumberController,
                    style: TextStyle(
                        fontSize: 14,
                        color: App.theme.textTheme.bodyLarge?.color),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
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
                    controller: contractDateController,
                    style: TextStyle(
                        fontSize: 14,
                        color: App.theme.textTheme.bodyLarge?.color),
                    textInputAction: TextInputAction.next,
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
                    controller: officeConsultantIdController,
                    style: TextStyle(fontSize: 14, color: App.theme.textTheme.bodyLarge?.color),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
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
                  padding:
                      EdgeInsets.only(top: 12, bottom: 12, right: 12, left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField2(
                          controller: numberPhoneController,
                          style: TextStyle(
                              fontSize: 14,
                              color: App.theme.textTheme.bodyLarge?.color),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration.collapsed(
                            hintText: "مثال: 09123333333",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: verifyNumberPhone,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 12),
                          child: Text(
                            "تایید شماره",
                            style: TextStyle(
                              color: Themes.blue,
                              fontSize: 11,
                              fontFamily: "IranSansBold",
                            ),
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
            child: BlockBtn(text: "استعلام قرارداد", onTap: inquiryContract),
          ),
        ],
      ),
    );
  }

  //event listeners
  void verifyNumberPhone() {
    //todo: implement event listener
  }

  void inquiryContract() {
    //todo: implement event listener
  }
}
