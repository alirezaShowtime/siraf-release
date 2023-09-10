import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';
import 'package:siraf3/widgets/text_field_2.dart';

import 'preview_estate_registration_screen.dart';

class EstateRegistrationFormScreen extends StatefulWidget {
  @override
  State<EstateRegistrationFormScreen> createState() => _EstateRegistrationFormScreen();
}

class _EstateRegistrationFormScreen extends State<EstateRegistrationFormScreen> {
  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessIdController = TextEditingController();
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController officeTelephoneController = TextEditingController();
  TextEditingController bossNameController = TextEditingController();
  TextEditingController bossNumberPhoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController trackingController = TextEditingController();
  TextEditingController Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        titleText: "ثبت مشخصات",
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              field(
                padding: const EdgeInsets.only(
                    top: 30, left: 10, right: 10, bottom: 10),
                controller: businessNameController,
                labelText: "نام تجاری دفتر املاک",
                hintText: "مثال: دپارتمان املاک شهر",
                suffixText: "| بارگذاری علامت تجاری ",
                onPressedSuffix: attachSymbolBusiness,
              ),
              field(
                controller: businessIdController,
                labelText: "شناسه صنفی",
                hintText: "مثال: 0467946333",
                suffixText: "| بارگذاری پروانه کسب ",
                onPressedSuffix: attachLicense,
              ),
              field(
                controller: officeAddressController,
                labelText: "آدرس دفتر املاک",
                hintText: "مثال: تهران، ونک",
                suffixText: "| تعیین شهر و موقعیت ",
                onPressedSuffix: attachLocation,
              ),
              field(
                controller: officeTelephoneController,
                labelText: "شماره تلفن دفتر املاک(اختیاری)",
              ),
              field(
                controller: bossNameController,
                labelText: "نام و نام خانوادگی مدیر دفتر املاک",
                suffixText: "| بارگذاری کارت ملی",
                onPressedSuffix: attachNationalCode,
              ),
              field(
                controller: bossNumberPhoneController,
                labelText: "شماره موبایل مدیر دفتر املاک",
                hintText: "مثال: *******0912",
              ),
              field(
                controller: trackingController,
                labelText: "کد معرف",
              ),
              field(
                controller: descriptionController,
                labelText: "توضیحات",
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: MaterialButton(
              onPressed: next,
              color: App.theme.primaryColor,
              child: Row(
                children: [
                  Text(
                    "بعدی",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                  icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white, size: 15),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget field({
    required TextEditingController controller,
    String? labelText,
    String? hintText,
    String? suffixText,
    EdgeInsets? padding,
    void Function()? onPressedSuffix,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(10),
      child: TextField2(
        controller: controller,
        style: TextStyle(fontSize: 11),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          suffixIcon: suffixText == null
              ? null
              : MyTextButton(
                  onPressed: onPressedSuffix,
                  rippleColor: Colors.black,
                  child: Text(
                    suffixText,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "IranSansBold",
                      fontSize: 10,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  //event listeners
  void next() {
    //todo: implement event listener
    if (businessNameController.value.text.isEmpty ||
        businessIdController.value.text.isEmpty ||
        officeAddressController.value.text.isEmpty ||
        officeTelephoneController.value.text.isEmpty ||
        bossNameController.value.text.isEmpty ||
        bossNumberPhoneController.value.text.isEmpty ||
        descriptionController.value.text.isEmpty ||
        trackingController.value.text.isEmpty) {}

    Navigator.push(context, MaterialPageRoute(builder: (_) => PreviewEstateRegistrationScreen()));
  }

  void attachSymbolBusiness() {
    //todo: implement event listener
  }

  void attachLicense() {
    //todo: implement event listener
  }

  void attachLocation() {
    //todo: implement event listener
  }

  void attachNationalCode() {
    //todo: implement event listener
  }
}
