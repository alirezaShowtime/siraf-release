import 'package:flutter/material.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/themes.dart';

class CompareItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CompareItem();

  List<File>? list;

  CompareItem({this.list});
}

class _CompareItem extends State<CompareItem> {
  List<Widget> list() {
    return [
      Align(alignment: Alignment.center, child: imageAndNameWidget()),
      Padding(
        padding: const EdgeInsets.only(top: 7.5, bottom: 7.5, right: 20),
        child: Text(
          "text test",
          style: TextStyle(
            color: Themes.textGrey,
            fontSize: 12,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 7.5, bottom: 7.5, right: 20),
        child: Text(
          "text test",
          style: TextStyle(
            color: Themes.textGrey,
            fontSize: 12,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 7.5, bottom: 7.5, right: 20),
        child: Text(
          "text test",
          style: TextStyle(
            color: Themes.textGrey,
            fontSize: 12,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 7.5, bottom: 7.5, right: 20),
        child: Text(
          "text test",
          style: TextStyle(
            color: Themes.textGrey,
            fontSize: 12,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 7.5, bottom: 7.5, right: 20),
        child: Text(
          "text test",
          style: TextStyle(
            color: Themes.textGrey,
            fontSize: 12,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 7.5, bottom: 7.5, right: 20),
        child: Text(
          "text test",
          style: TextStyle(
            color: Themes.textGrey,
            fontSize: 12,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.list == null ? 120 : 30,
      height: 3000,
      color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //todo: list variable is temporary
        children: widget.list == null ? list() : generate(),
      ),
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

  List<Widget> generate() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 160 + 7.5, bottom: 7.5, right: 20),
        child: Text(
          "text test",
          style: TextStyle(
            color: Themes.textGrey,
            fontSize: 12,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 7.5, bottom: 7.5, right: 20),
        child: Text(
          "text test",
          style: TextStyle(
            color: Themes.textGrey,
            fontSize: 12,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 7.5, bottom: 7.5, right: 20),
        child: Text(
          "text test",
          style: TextStyle(
            color: Themes.textGrey,
            fontSize: 12,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 7.5, bottom: 7.5, right: 20),
        child: Text(
          "text test test ",
          style: TextStyle(
            color: Themes.textGrey,
            fontSize: 12,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 7.5, bottom: 7.5, right: 20),
        child: Text(
          "text test",
          style: TextStyle(
            color: Themes.textGrey,
            fontSize: 12,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 7.5, bottom: 7.5, right: 20),
        child: Text(
          "text test",
          style: TextStyle(
            color: Themes.textGrey,
            fontSize: 12,
          ),
        ),
      ),
    ];
  }
}
