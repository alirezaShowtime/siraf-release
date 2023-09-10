import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/main.dart';

class VerifyNumberPhoneScreen extends StatefulWidget {
  @override
  State<VerifyNumberPhoneScreen> createState() => _VerifyNumberPhoneScreen();
}

class _VerifyNumberPhoneScreen extends State<VerifyNumberPhoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(titleText: "تایید شماره همراه"),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "لطفا کد تاییدی که به شماره # ارسال شده را وارد نمایید.",
            style: TextStyle(
              fontSize: 13,
              fontFamily: "IranSansBold",
              color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "تغییر شماره",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        "ارسال مجدد #",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 45,
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: TextField2(
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: InputBorder.none,
                      hintText: "- - - - - -",
                      hintStyle: TextStyle(
                        fontFamily: "IranSansBold",
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _verifyNumberPhone,
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Themes.blue,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                    ),
                    child: Text(
                      "تایید",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: "IranSansBold",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //event listeners
  void _verifyNumberPhone() {
    //todo: implement event listener
  }
}
