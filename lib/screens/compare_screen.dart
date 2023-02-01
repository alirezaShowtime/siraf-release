import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/compare_item.dart';
import 'package:siraf3/widgets/my_back_button.dart';

class CompareScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CompareScreen();
}

class _CompareScreen extends State<CompareScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: MyBackButton(),
        elevation: 0.7,
        title: AppBarTitle("مقایسه"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  top: 0,
                  right: 0,
                  child: _CompareItem(list: []),
                ),
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10 + 1,
                  itemBuilder: (BuildContext context, int i) {
                    if (i == 0) return SizedBox(width: 40);
                    return _CompareItem();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CompareItemC();

  List<File>? list;

  _CompareItem({this.list});
}

class _CompareItemC extends State<_CompareItem> {
  List<Widget> list() {
    return [
      Align(alignment: Alignment.center, child: imageAndNameWidget()),
      SizedBox(height: 7.5),
      Text(
        "text test",
        style: TextStyle(
          color: Themes.textGrey,
          fontSize: 12,
        ),
      ),
      SizedBox(height: 15),
      Text(
        "text test",
        style: TextStyle(
          color: Themes.textGrey,
          fontSize: 12,
        ),
      ),
      SizedBox(height: 15),
      Text(
        "text test",
        style: TextStyle(
          color: Themes.textGrey,
          fontSize: 12,
        ),
      ),
      SizedBox(height: 15),
      Text(
        "text test",
        style: TextStyle(
          color: Themes.textGrey,
          fontSize: 12,
        ),
      ),
      SizedBox(height: 15),
      Text(
        "text test",
        style: TextStyle(
          color: Themes.textGrey,
          fontSize: 12,
        ),
      ),
      SizedBox(height: 15),
      Text(
        "text test",
        style: TextStyle(
          color: Themes.textGrey,
          fontSize: 12,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.list == null ? 120 : null,
      height: 3000,
      child: widget.list == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //todo: list variable is temporary
              children: list(),
            )
          : generate(),
    );
  }

  Widget imageAndNameWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, top: 5),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: NetworkImage(
                  "https://www.ers.ga.gov/sites/main/files/imagecache/carousel/main-images/camera_lense_0.jpeg"),
              // image: NetworkImage(widget.file.images?.first.path ?? ""),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image(
                image: AssetImage("assets/images/image_not_avialable_2.png"),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "فایل شماره دو",
            style: TextStyle(color: Themes.textGrey, fontSize: 11),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget generate() {
    return Container(
      margin: EdgeInsets.only(top: 137.5),
      padding: EdgeInsets.only(left: 8, right: 6, top: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 7.5),
            child: Text(
              "text test",
              style: TextStyle(
                color: Themes.textGrey,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(height: 7.5),
          Text(
            "text test",
            style: TextStyle(
              color: Themes.textGrey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "text test",
            style: TextStyle(
              color: Themes.textGrey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "text test",
            style: TextStyle(
              color: Themes.textGrey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "text test",
            style: TextStyle(
              color: Themes.textGrey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "text test",
            style: TextStyle(
              color: Themes.textGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
