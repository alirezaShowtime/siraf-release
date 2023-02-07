import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';
import 'package:siraf3/widgets/text_field_2.dart';

class AgencyRegistrationFormScreen extends StatefulWidget {
  @override
  State<AgencyRegistrationFormScreen> createState() => _AgencyRegistrationFormScreen();
}

class _AgencyRegistrationFormScreen extends State<AgencyRegistrationFormScreen> {




  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessIdController = TextEditingController();
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController officeTelephoneController = TextEditingController();
  TextEditingController bossNameController = TextEditingController();
  TextEditingController bossNumberPhoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SimpleAppBar(
          titleText: "ثبت مشخصات",
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: TextField2(
                    controller: businessNameController,
                    style: TextStyle(fontSize: 11),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "نام تجاری دفتر املاک",
                      hintText: "مثال: دپارتمان املاک شهر",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      suffixIcon: MyTextButton(
                        onPressed: attachSymbolBusiness,
                        rippleColor: Colors.black,
                        child: Text(
                          "| بارگذاری علامت تجاری ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField2(
                    controller: businessIdController,
                    style: TextStyle(fontSize: 11),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "شناسه صنفی",
                      hintText: "مثال: 0467946333",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      suffixIcon: MyTextButton(
                        onPressed: attachSymbolBusiness,
                        rippleColor: Colors.black,
                        child: Text(
                          "| بارگذاری پروانه کسب ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField2(
                    controller: officeAddressController,
                    style: TextStyle(fontSize: 11),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "آدرس دفتر املاک",
                      hintText: "مثال: تهران، ونک",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      suffixIcon: MyTextButton(
                        onPressed: attachSymbolBusiness,
                        rippleColor: Colors.black,
                        child: Text(
                          "| تعیین شهر و موقعیت ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField2(
                    controller: officeTelephoneController,
                    style: TextStyle(fontSize: 11),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "شماره تلفن دفتر املاک(اختیاری)",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField2(
                    controller: bossNameController,
                    style: TextStyle(fontSize: 11),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "نام و نام خانوادگی مدیر دفتر املاک",
                      suffixIcon: MyTextButton(
                        onPressed: attachSymbolBusiness,
                        rippleColor: Colors.black,
                        child: Text(
                          "| بارگذاری کارت ملی",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField2(
                    controller: bossNumberPhoneController,
                    style: TextStyle(fontSize: 11),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "شماره موبایل مدیر دفتر املاک",
                      hintText: "مثال: *******0912",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      suffixIcon: MyTextButton(
                        onPressed: attachSymbolBusiness,
                        rippleColor: Colors.black,
                        child: Text(
                          "| بارگذاری شماره موبایل",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField2(
                    controller: descriptionController,
                    style: TextStyle(fontSize: 11),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "کد معرف",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField2(
                    controller: descriptionController,
                    style: TextStyle(fontSize: 11),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "توضیحات",
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: MaterialButton(
                onPressed: next,
                color: Themes.primary,
                child: Row(
                  children: [
                    Text(
                      "بعدی",
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                    icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 15),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          ],
        ));
  }

  Widget field()

  void attachSymbolBusiness() {}

  void next() {

    if(){}

  }
}
