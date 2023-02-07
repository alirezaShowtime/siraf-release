import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/my_alert_dialog.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_content_dialog.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/title_dialog.dart';

class RequestFileShowScreen extends StatefulWidget {
  @override
  State<RequestFileShowScreen> createState() => _RequestFileShowScreen();
}

class _RequestFileShowScreen extends State<RequestFileShowScreen> {
  List<Map<String, dynamic>> list = [
    {
      "agentName": "حمید نیایش",
      "agencyName": "املاک خرم",
      "star": 3,
      "numberPhone": "09124304554",
    },
    {
      "agentName": "حمید نیایش",
      "agencyName": "املاک خرم",
      "star": 3,
      "numberPhone": "09124304554",
    },
    {
      "agentName": "حمید نیایش",
      "agencyName": "املاک خرم",
      "star": 3,
      "numberPhone": "09124304554",
    },
    {
      "agentName": "حمید نیایش",
      "agencyName": "املاک خرم",
      "star": 3,
      "numberPhone": "09124304554",
    },
    {
      "agentName": "حمید نیایش",
      "agencyName": "املاک خرم",
      "star": 3,
      "numberPhone": "09124304554",
    },
    {
      "agentName": "حمید نیایش",
      "agencyName": "املاک خرم",
      "star": 3,
      "numberPhone": "09124304554",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0.7,
        leading: MyBackButton(),
        backgroundColor: Themes.appBar,
        automaticallyImplyLeading: false,
        title: AppBarTitle("درخواست های من"),
        actions: [
          IconButton(onPressed: showConfirmDialog, icon: icon(CupertinoIcons.delete, size: 20)),
          MyPopupMenuButton(
            items: [
              popupMenuItemWithIcon(title: "ویرایش فایل", iconDate: Icons.edit_rounded, onTap: onClickEditFile),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 18, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "خرید | تهران ولیصعر",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "محدوده قیمت: از # تا # تومان",
              style: TextStyle(
                color: Themes.textGrey,
                fontSize: 11,
              ),
            ),
            Text(
              "محدوده متراژ: از # تا # متر",
              style: TextStyle(
                color: Themes.textGrey,
                fontSize: 11,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "بنخیحسنب حخنیحخنب خنیحخبن خحیسنب خحنیبخحن حخیبن حخیسنبحخ ینسب حخنیسبخح نیخحبن خحسنیبخیسن ب",
              style: TextStyle(
                color: Themes.textGrey,
                fontSize: 11,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "1 ساعت پیش",
                    style: TextStyle(
                      color: Themes.textGrey,
                      fontSize: 9,
                    ),
                  ),
                  Text(
                    "کد رهگیری: #",
                    style: TextStyle(
                      color: Themes.textGrey,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "وضعیت: تایید شده توسط مشاور/مشاوران زیر",
              style: TextStyle(
                //todo: text color will be changed sort by status
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  return item(list[i]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget item(Map<String, dynamic> agent) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: NetworkImage("https://www.seiu1000.org/sites/main/files/imagecache/hero/main-images/camera_lense_0.jpeg"),
                  height: 40,
                  width: 40,
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, eventProgress) {
                    if (eventProgress == null) return child;
                    return Image.asset(
                      "assets/images/profile.png",
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                    );
                  },
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agent["agentName"],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "(${agent["agencyName"]})",
                    style: TextStyle(fontSize: 10, color: Themes.textGrey),
                  ),
                  SizedBox(height: 6),
                  RatingBar.builder(
                    initialRating: (agent["star"] as int).toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.25),
                    itemBuilder: (context, _) => icon(Icons.star, color: Colors.amber),
                    itemSize: 10,
                    onRatingUpdate: (double value) {},
                    updateOnDrag: false,
                    ignoreGestures: true,
                    unratedColor: Colors.grey.shade300,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(onPressed: () => startChat(agent), icon: icon(Icons.chat_outlined, color: Colors.grey.shade500)),
              IconButton(onPressed: () => call(agent["numberPhone"]), icon: icon(Icons.phone_rounded, color: Colors.grey.shade500)),
            ],
          ),
        ],
      ),
    );
  }

  //event listeners
  void showConfirmDialog() => showDialog(
        context: context,
        builder: (context) => MyAlertDialog(
          title: TitleDialog(title: "حذف درخواست فایل"),
          content: MyContentDialog(content: "آیا واقعا میخواهید این درخواست را پاک کنید؟"),
          actions: [
            MyTextButton(text: "حذف", onPressed: onClickRemoveFile, rippleColor: Colors.red),
            MyTextButton(text: "لغو", onPressed: () => Navigator.pop(context)),
          ],
        ),
      );

  void onClickEditFile() {
    //todo: implement event listener
  }

  void call(agent) {
    //todo: implement event listener
  }

  void startChat(Map<String, dynamic> agent) {
    //todo: implement event listener
  }

  void onClickRemoveFile() {
    //todo: implement event listener
  }
}
