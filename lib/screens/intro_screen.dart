import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return WillPopScope(
      onWillPop: () async {
        if (currentPage == 1) {
          return true;
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: IntroductionScreen(
            rawPages: [
              _buildPage(
                  imagePath: "assets/images/intro_1.gif",
                  description: "سیراف پل ارتباطی شما با دفاتر املاک"),
              _buildPage(
                  imagePath: "assets/images/intro_2.gif",
                  description: "تمام فایل های دفاتر املاک در دستان شما"),
              _buildPage(
                  imagePath: "assets/images/intro_3.gif",
                  description: "ملک های اطرافت رو از روی نقشه پیدا کن"),
              _buildPage(
                  imagePath: "assets/images/intro_4.gif",
                  description:
                      "قبل از معامله، استعلامات ثبتی لازم رو بگیر و کمیسیون معامله ات رو آنی حساب کن"),
              _buildPage(
                  imagePath: "assets/images/intro_5.gif",
                  description: "ملک رو به دفاتر املاک قانونی بسپار"),
              _buildPage(
                  imagePath: "assets/images/intro_6.gif",
                  description: "24 ساعته پشتیبان مشکلات شما هستیم"),
            ],
            showNextButton: true,
            showSkipButton: false,
            showBackButton: false,
            showDoneButton: true,
            next: Text(
              "بعدی",
              style: TextStyle(color: Themes.primary, fontSize: 16),
            ),
            done: Text(
              "شروع",
              style: TextStyle(color: Themes.primary, fontSize: 16),
            ),
            onDone: () async {
              (await SharedPreferences.getInstance()).setBool("IS_INTRO_SHOW", true);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
            },
            rtl: true,
            globalBackgroundColor: Colors.white,
            globalHeader: Container(
              padding: EdgeInsets.only(right: 15, top: 10),
              child: Text(
                "${currentPage}/6",
                style: TextStyle(
                    fontSize: 18,
                    color: Themes.secondary2,
                    fontFamily: "IranSansBold"),
              ),
            ),
            dotsDecorator: DotsDecorator(
                color: Themes.textGrey,
                activeColor: Themes.primary,
                shape: CircleBorder(),
                size: Size(7, 7),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                activeSize: Size(14, 7),
                spacing: EdgeInsets.only(right: 3)),
            bodyPadding: EdgeInsets.only(top: 0),
            controlsPadding: EdgeInsets.symmetric(vertical: 20),
            onChange: (index) {
              setState(() {
                currentPage = index + 1;
              });
            },
            scrollPhysics: AlwaysScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }

  int currentPage = 1;

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  Widget _buildPage({required String imagePath, required String description}) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(imagePath),
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "IranSansBold",
                  fontSize: 20,
                  wordSpacing: 2.5,
                  color: Themes.secondary2),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
