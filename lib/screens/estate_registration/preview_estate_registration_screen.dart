import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_card.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';

class PreviewEstateRegistrationScreen extends StatefulWidget {
  @override
  State<PreviewEstateRegistrationScreen> createState() => _PreviewEstateRegistrationScreen();
}

class _PreviewEstateRegistrationScreen extends State<PreviewEstateRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(titleText: "پیش نمایش ثبت نام"),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  MyCard(
                    title: "پیش نمایش",
                    background: Colors.white,
                    child: Column(
                      children: [
                        item("title", "value"),
                        item("title", "value"),
                        item("title", "value"),
                        item("title", "value"),
                        item("title", "value"),
                        item("title", "value"),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "آدرس دفتر املاک",
                            style: TextStyle(
                              color: Themes.text,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 15),
                          child: Text(
                            "fld[spkf[d نیحخنبخح ینبحخ نبحخینبح خینسبحخ نیبحخ نسیبخحیسنبخح ینب یحسخبنیسحخب ",
                            style: TextStyle(
                              color: Themes.textGrey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        //todo: implement map widget
                        Wrap(
                          spacing: 10,
                          direction: Axis.horizontal,
                          children: [
                            imagePreview(
                              image: "fdsfsdfsdfds",
                              title: "fdsfsdfsdfds",
                            ),
                            imagePreview(
                              image: "fdsfsdfsdfds",
                              title: "fdsfsdfsdfds",
                            ),
                            imagePreview(
                              image: "fdsfsdfsdfds",
                              title: "fdsfsdfsdfds",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyTextButton(
                    onPressed: previous,
                    text: "قبلی",
                    rippleColor: Themes.textGrey,
                  ),
                  MaterialButton(
                    onPressed: done,
                    color: Themes.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Text(
                          "تایید نهایی",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon(Icons.done_rounded, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Themes.text,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Themes.textGrey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget imagePreview({required String image, required String title}) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image(
            image: AssetImage(image),
            height: 80,
            width: 80,
            loadingBuilder: (context, child, progressEvent) {
              if (progressEvent == null) return child;
              return Container(
                height: 80,
                width: 80,
                alignment: Alignment.center,
                color: Colors.grey.shade100,
                child: Text(
                  "در حال باگذاری",
                  style: TextStyle(
                    color: Themes.textGrey,
                    fontSize: 10,
                  ),
                ),
              );
            },
            errorBuilder: (context, child, _) {
              return Container(
                height: 80,
                width: 80,
                alignment: Alignment.center,
                color: Colors.grey.shade100,
                child: Text(
                  "در حال باگذاری",
                  style: TextStyle(
                    color: Themes.textGrey,
                    fontSize: 10,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            color: Themes.textGrey,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  //event listeners

  void previous() {
    //todo: implement event listener
    Navigator.pop(context);
  }

  void done() {
    //todo: implement event listener
  }
}
