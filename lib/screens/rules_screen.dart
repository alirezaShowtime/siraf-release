import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/widgets/my_app_bar.dart';
import 'package:siraf3/widgets/my_back_button.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  List<String> titles = [
    "درباره سیراف",
    "شرایط و قوانین استفاده",
    "ثبت فایل و درخواست :",
    "گردش کار پذیرش فایل :",
    "گفتگو ها :",
    "امتیاز ها :",
    "محاسبه کمیسیون :",
    "استعلامات ثبتی :",
    "بلاگ سیراف :",
    "پشتیبانی :",
    "اطلاع رسانی :",
    "حریم خصوصی کاربران :",
    "بروز رسانی :",
    "حقوق مادی و معنوی :",
  ];
  List<String> texts = [];

  @override
  initState() {
    super.initState();

    setTexts();
  }

  setTexts() async {
    var guide = await DefaultAssetBundle.of(context).loadString('assets/images/about_us.txt');

    setState(() {
      texts = guide.split("#");
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: App.getSystemUiOverlay(),
      child: Scaffold(
        appBar: MyAppBar(
          title: Text(
            "درباره سیراف و قوانین",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          automaticallyImplyLeading: false,
          leading: MyBackButton(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: texts.map<Widget>((e) => _buildWithTitle(e, titles[texts.indexOf(e)])).toList(),
            ),
          ),
        ),
      ),
    );
  }

  _buildWithTitle(String text, String title) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "IranSansBold",
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            text,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "IranSansMedium",
            ),
          ),
        ],
      ),
    );
  }
}
