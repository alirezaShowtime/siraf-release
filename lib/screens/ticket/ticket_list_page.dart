import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/badge.dart';
import 'package:siraf3/widgets/my_back_button.dart';

class TicketListPage extends StatefulWidget {
  @override
  State<TicketListPage> createState() => _TicketListPage();
}

class _TicketListPage extends State<TicketListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.7,
        titleSpacing: 0,
        leading: MyBackButton(),
        title: Row(
          children: [
            AppBarTitle("تیک های پشتیبانی"),
            Badge(text: "12"),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, i) {
          return item();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createTicket,
        backgroundColor: Themes.primary,
        shape: CircleBorder(),
        tooltip: "ایجاد تیکت",
        child: icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget item() {
    return Container(
      height: 65,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: NetworkImage("https://www.seiu1000.org/sites/main/files/imagecache/hero/main-images/camera_lense_0.jpeg"),
                  width: 50,
                  height: 50,
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Image.asset(
                      "assets/images/profile.png",
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 3, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "ثبت و در خواست",
                          style: TextStyle(
                            fontSize: 13,
                            color: Themes.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "|",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "عدم تایید مدارک",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Themes.textGrey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "با سلام فایل شماره ۱۱۸ تکراری نیست ولی تایید نشده است.",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Themes.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Badge(text: "23"),
              Text(
                "12:54",
                style: TextStyle(
                  color: Themes.textGrey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //event listeners
  void createTicket() {
    //todo: Implement event listener
  }
}
