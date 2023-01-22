import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:url_launcher/url_launcher.dart';

class EstateGuide extends StatefulWidget {
  const EstateGuide({super.key});

  @override
  State<EstateGuide> createState() => _EstateGuideState();
}

class _EstateGuideState extends State<EstateGuide> {
  String text = "";

  String learn_video_url = "https://siraf.app";
  String googleStreatViewDownloadLink = "https://siraf.app";
  String krpanoDownloadLink = "https://siraf.app";

  @override
  void initState() {
    super.initState();

    setTexts();
  }

  setTexts() async {
    var guide = await DefaultAssetBundle.of(context)
        .loadString('assets/images/estate_guide.txt');

    setState(() {
      text = guide;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Themes.appBar,
        elevation: 0.7,
        title: Text(
          "راهنمای انتخاب روش ثبت فایل",
          style: TextStyle(
            color: Themes.text,
            fontSize: 15,
          ),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Themes.icon,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "انتخاب دفتر / دفاتر املاک",
                style: TextStyle(
                  fontSize: 14,
                  color: Themes.text,
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
                  color: Themes.text,
                ),
              ),
              SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
