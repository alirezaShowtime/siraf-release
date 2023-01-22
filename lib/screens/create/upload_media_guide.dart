import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadMediaGuide extends StatefulWidget {
  const UploadMediaGuide({super.key});

  @override
  State<UploadMediaGuide> createState() => _UploadMediaGuideState();
}

class _UploadMediaGuideState extends State<UploadMediaGuide> {
  String image_guide = "";
  String video_guide = "";
  String tour_guide = "";

  String learn_video_url = "https://siraf.app";
  String googleStreatViewDownloadLink = "https://siraf.app";
  String krpanoDownloadLink = "https://siraf.app";

  @override
  void initState() {
    super.initState();

    setTexts();
  }

  setTexts() async {
    var imageGuide = await DefaultAssetBundle.of(context)
        .loadString('assets/images/image_guide.txt');
    var videoGuide = await DefaultAssetBundle.of(context)
        .loadString('assets/images/video_guide.txt');
    var tourGuide = await DefaultAssetBundle.of(context)
        .loadString('assets/images/tour_guide.txt');

    setState(() {
      image_guide = imageGuide;
      video_guide = videoGuide;
      tour_guide = tourGuide;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Themes.appBar,
        elevation: 0.7,
        title: Text(
          "راهنمای آپلود فایل های تصویری",
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
                "تصویر (نقشه)",
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
                image_guide,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "IranSansMedium",
                  color: Themes.text,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "ویدیو",
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
                video_guide,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "IranSansMedium",
                  color: Themes.text,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "تور مجازی",
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
                tour_guide,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "IranSansMedium",
                  color: Themes.text,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(learn_video_url))) {
                    launchUrl(Uri.parse(learn_video_url),
                        mode: LaunchMode.externalApplication);
                  } else {
                    notify(
                        "متاسفانه نتوانستیم لینک را بازکنیم به پشتیبانی اطلاع دهید تا شما را راهنمایی کند.");
                  }
                },
                child: Text(
                  "جهت مشاهده آموزش ساخت تور مجازی کلیک کنید.",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "IranSansMedium",
                    color: Themes.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  if (await canLaunchUrl(
                      Uri.parse(googleStreatViewDownloadLink))) {
                    launchUrl(Uri.parse(googleStreatViewDownloadLink),
                        mode: LaunchMode.externalApplication);
                  } else {
                    notify(
                        "متاسفانه نتوانستیم لینک را بازکنیم به پشتیبانی اطلاع دهید تا شما را راهنمایی کند.");
                  }
                },
                child: Text(
                  "لینک دانلود اپلیکیشن Google streat view",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "IranSansMedium",
                    color: Themes.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(krpanoDownloadLink))) {
                    launchUrl(Uri.parse(krpanoDownloadLink),
                        mode: LaunchMode.externalApplication);
                  } else {
                    notify(
                        "متاسفانه نتوانستیم لینک را بازکنیم به پشتیبانی اطلاع دهید تا شما را راهنمایی کند.");
                  }
                },
                child: Text(
                  "لینک دانلود نرم افزار krpano",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "IranSansMedium",
                    color: Themes.primary,
                    decoration: TextDecoration.underline,
                  ),
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
