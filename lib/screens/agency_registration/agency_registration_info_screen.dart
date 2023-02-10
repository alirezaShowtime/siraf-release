import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/agency_registration/agency_registration_form_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_text_button.dart';

class AgencyRegistrationInfoScreen extends StatefulWidget {
  @override
  State<AgencyRegistrationInfoScreen> createState() =>
      _AgencyRegistrationInfoScreen();
}

class _AgencyRegistrationInfoScreen
    extends State<AgencyRegistrationInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: MyBackButton(),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        elevation: 0.7,
        backgroundColor: Themes.appBar,
        title: AppBarTitle("ثبت دفتر املاک"),
        actions: [
          IconButton(onPressed: share, icon: icon(Icons.share_rounded))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 50, left: 10, right: 10),
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  child: Text(
                    "مزایای ثبت دفتر املاک در سیراف",
                    style: TextStyle(
                      color: Themes.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                item(
                  index: 1,
                  title: "مدیریت کامل دفتر املاک",
                  subtitle: "فایل ها، مشتریان، مشاوران، قراردادها و ...",
                ),
                item(
                  index: 2,
                  title: "دسترسی به ویترین مشتریان و فایل های اختصاصی سیراف",
                  subtitle:
                      "سیراف در کنار شما و برای شما فایل و مشتری معرفی مینماید",
                ),
                item(
                  index: 3,
                  title: "سهولت در ارتباط با مشتریان",
                  subtitle:
                      "گفتگوی آنلاین، اشترام گذاری چند فایل برای مشتری و ...",
                ),
                item(
                  index: 4,
                  title: "بهره مندی از امکانات منحصر بفرد برای ارائه",
                  subtitle: "تور مجازی، ویدیو، نقشه، عکس و ...",
                ),
                item(
                  index: 5,
                  title: "امکان تنظیم و مدیریت انواع قراردادهای ملکی",
                  subtitle: "انواع قراردادهای ملکی و تنظیم قراردادهای اختصاصی",
                ),
                item(
                  index: 6,
                  title: "صرفه جویی در زمان و هزینه و افزایش سرعت و بهره وری",
                ),
                item(index: 7, title: "معرفی دفتر املاک شما به کاربران سیراف"),
                item(
                    index: 8,
                    title: "بهره مندی از محتواهای آموزشی اختصاصی حوزه املاک"),
                item(
                    index: 9,
                    title:
                        "امکان دسترسی به سامانه از راه دور، تنها از طریق تلفن همراه"),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 30),
                  child: MyTextButton(
                    onPressed: viewIntroductionVideo,
                    rippleColor: Themes.primary,
                    child: Row(
                      children: [
                        Text(
                          "مشاهده ویدیو معرفی",
                          style: TextStyle(
                            color: Themes.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon(Icons.arrow_right_rounded, color: Themes.primary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1),
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyTextButton(
                  onPressed: followUp,
                  text: "پیگیری کردن",
                  rippleColor: Themes.primary,
                ),
                MaterialButton(
                  onPressed: registerAgency,
                  color: Themes.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "ثبت نام",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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

  Widget item({required int index, required String title, String? subtitle}) {
    return Container(
      height: 65,
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${index}.${title}",
            style: TextStyle(
                color: Themes.text, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10),
              child: Text(
                "(${subtitle})",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
        ],
      ),
    );
  }

  //event listeners
  void share() {
    //todo: implement event listener
  }

  void followUp() {
    //todo: implement event listener
  }

  void registerAgency() {
    //todo: implement event listener
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => AgencyRegistrationFormScreen()));
  }

  void viewIntroductionVideo() {
    //todo: implement event listener
  }
}
