import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/request_file/request_file_show_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';

class RequestListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RequestListScreen();
}

class _RequestListScreen extends State<RequestListScreen> {
  //todo: selecting item when longClick is`t done
  //todo: String type is a test type, this must be a model class
  List<String> selectedFiles = [];

  //todo: Map<String, dynamic> type of requests variable is a test type is type will be changed later
  List<Map<String, dynamic>> requests = [
    {
      "type": "فروش",
      "title": "آپارتمان 160 متری مناطق الهیه ولنجک",
      "time": "1 ساعت پیش",
      "trackingCode": 58903485,
      "status": "در انتظار تایید",
    },
    {
      "type": "فروش",
      "title": "آپارتمان 160 متری مناطق الهیه ولنجک",
      "time": "1 ساعت پیش",
      "trackingCode": 58903485,
      "status": "در انتظار تایید",
    },
    {
      "type": "فروش",
      "title": "آپارتمان 160 متری مناطق الهیه ولنجک",
      "time": "1 ساعت پیش",
      "trackingCode": 58903485,
      "status": "در انتظار تایید",
    },
    {
      "type": "فروش",
      "title": "آپارتمان 160 متری مناطق الهیه ولنجک",
      "time": "1 ساعت پیش",
      "status": "در انتظار تایید",
      "trackingCode": 58903485,
    },
    {
      "type": "فروش",
      "title": "آپارتمان 160 متری مناطق الهیه ولنجک",
      "time": "1 ساعت پیش",
      "trackingCode": 58903485,
      "status": "در انتظار تایید",
    },
    {
      "type": "فروش",
      "title": "آپارتمان 160 متری مناطق الهیه ولنجک",
      "time": "1 ساعت پیش",
      "trackingCode": 58903485,
      "status": "در انتظار تایید",
    },
    {
      "type": "فروش",
      "title": "آپارتمان 160 متری مناطق الهیه ولنجک",
      "time": "1 ساعت پیش",
      "trackingCode": 58903485,
      "status": "در انتظار تایید",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0.7,
        leading: MyBackButton(),
        backgroundColor: Themes.appBar,
        automaticallyImplyLeading: false,
        title: AppBarTitle("درخواست های من"),
        actions: [
          IconButton(onPressed: requestFile, icon: icon(Icons.add)),
          if (selectedFiles.length > 0) IconButton(onPressed: removeFile, icon: icon(CupertinoIcons.delete)),
          MyPopupMenuButton(
            icon: icon(Icons.sort_rounded),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text("جدیدترین", style: TextStyle(fontSize: 12))),
              PopupMenuItem(child: Text("قدیمی ترین", style: TextStyle(fontSize: 12))),
              PopupMenuItem(child: Text("در انتظار تایید", style: TextStyle(fontSize: 12))),
              PopupMenuItem(child: Text("در انتظار پذیرش", style: TextStyle(fontSize: 12))),
              PopupMenuItem(child: Text("پذیرش شده", style: TextStyle(fontSize: 12))),
              PopupMenuItem(child: Text("عدم پذیرش", style: TextStyle(fontSize: 12))),
              PopupMenuItem(child: Text("رد شده", style: TextStyle(fontSize: 12))),
            ],
          ),
          MyPopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(child: Text("انتخاب همه", style: TextStyle(fontSize: 12))),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, i) {
          return item(requests[i]);
        },
      ),
    );
  }

  Widget item(Map<String, dynamic> model) {
    return InkWell(
      onTap: () => onClickItem(model),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${model["type"]} | ${model["title"]}",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              model["time"],
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 10,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${model["trackingCode"]}",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
                Text(
                  model["status"],
                  style: TextStyle(
                    //todo: I have an idea that the text color status will be sort the color base on status, for example green when the status is approved
                    color: Themes.text,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //event listeners

  void requestFile() {
    //todo: implement event listener
  }

  void removeFile() {
    //todo: implement event listener
  }

  void onClickItem(Map<String, dynamic> model) {
    //todo: implement event listener

    Navigator.push(context, MaterialPageRoute(builder: (_) => RequestFileShowScreen()));
  }
}
