import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/screens/webview_screen.dart';

class InquiryScreen extends StatefulWidget {
  const InquiryScreen({super.key});

  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "استعلامات ثبتی",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            CupertinoIcons.back,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              item(
                "تصدیق اصالت سند مالکیت",
                "https://my.ssaa.ir/portal/estate/originality-document/",
              ),
              SizedBox(height: 15),
              item(
                "تصدیق اصالت اسناد و اوراق دفاتر اسناد رسمی",
                "https://my.ssaa.ir/portal/ssar/originality-document",
              ),
              SizedBox(height: 15),
              item(
                "استعلام ممنوع الخروجی",
                "https://my.ssaa.ir/portal/executive/inquery-exitban",
              ),
              SizedBox(height: 15),
              item(
                "پیگیری استعلام الکترونیک ملک",
                "https://my.ssaa.ir/portal/ssar/request-status",
              ),
              SizedBox(height: 15),
              item(
                "استعلام شناسه ملی",
                "https://www.ilenc.ir/LegalPersonSearch.aspx",
              ),
              SizedBox(height: 15),
              item(
                "دفتر طلاق دارای ظرفیت ثبت واقعه",
                "https://my.ssaa.ir/portal/sset/notary-office-capacity",
              ),
              SizedBox(height: 15),
              item(
                "دفتر اسناد رسمی دارای ظرفیت ثبت سند",
                "https://my.ssaa.ir/portal/ssar/notary-office-capacity", // todo change link
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget item(String title, String url) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebViewScreen(title: title, url: url),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: App.theme.dialogBackgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                offset: Offset(-1, 0),
                color: Color.fromARGB(255, 88, 96, 112).withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
              BoxShadow(
                offset: Offset(1, 1),
                color: Color.fromARGB(255, 72, 85, 112).withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ]),
        width: double.infinity,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "IranSansMedium",
          ),
        ),
      ),
    );
  }
}
