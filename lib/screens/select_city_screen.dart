import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/accordion.dart';
import 'package:siraf3/widgets/icon_asset.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({super.key});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  bool onSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.background2,
      appBar: onSearching
          ? AppBar(
              backgroundColor: Color(0xffffffff),
              shadowColor: Color(0x50000000),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      onSearching = false;
                    });
                  },
                  icon: Image(
                    image: AssetImage("assets/images/ic_search.png"),
                    width: 24,
                    height: 24,
                    color: Themes.primary,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
              title: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "جستجو در شهر ها",
                  hintStyle: TextStyle(fontSize: 17, fontFamily: "Vazir"),
                ),
                style: TextStyle(fontSize: 17, fontFamily: "Vazir"),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      onSearching = false;
                    });
                  },
                  icon: Image(
                    image: AssetImage("assets/images/ic_back.png"),
                    width: 24,
                    height: 24,
                    color: Themes.primary,
                  ),
                ),
              ),
            )
          : AppBar(
              backgroundColor: Color(0xffffffff),
              shadowColor: Color(0x50000000),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Image(
                    image: AssetImage("assets/images/ic_reload.png"),
                    width: 24,
                    height: 24,
                    color: Themes.primary,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      onSearching = true;
                    });
                  },
                  icon: Image(
                    image: AssetImage("assets/images/ic_search.png"),
                    width: 24,
                    height: 24,
                    color: Themes.primary,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
              title: Text(
                "انتخاب شهر",
                style: TextStyle(
                  color: Themes.primary,
                  fontFamily: "Vazir",
                  fontSize: 18,
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {},
                  icon: Image(
                    image: AssetImage("assets/images/ic_back.png"),
                    width: 24,
                    height: 24,
                    color: Themes.primary,
                  ),
                ),
              ),
            ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  child: Row(children: [
                    Text(
                      "تهران",
                      style: TextStyle(
                        fontFamily: "Vazir",
                        color: Color(0xff000000),
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Typicons.delete,
                      color: Color(0xff707070),
                      size: 26,
                    )
                  ]),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Row(children: [
                    Text(
                      "اراک",
                      style: TextStyle(
                        fontFamily: "Vazir",
                        color: Color(0xff000000),
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Typicons.delete,
                      color: Color(0xff707070),
                      size: 26,
                    )
                  ]),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Row(children: [
                    Text(
                      "اردبیل",
                      style: TextStyle(
                        fontFamily: "Vazir",
                        color: Color(0xff000000),
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Typicons.delete,
                      color: Color(0xff707070),
                      size: 26,
                    )
                  ]),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Row(children: [
              IconAsset(
                icon: "ic_location_circle.png",
                color: Color(0xff707070),
                width: 22,
                height: 22,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                "انتخاب لوکیشن فعلی من (تهران)",
                style: TextStyle(
                  fontFamily: "Vazir",
                  color: Color(0xff000000),
                  fontSize: 17,
                ),
              ),
            ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(children: [
                Accordion(
                  title: Text(
                    "آذربایجان شرقی",
                    style: TextStyle(
                      fontFamily: "Vazir",
                      color: Color(0xff000000),
                      fontSize: 17,
                    ),
                  ),
                  content: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 15, right: 30),
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff000000),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Accordion(
                  title: Text(
                    "آذربایجان شرقی",
                    style: TextStyle(
                      fontFamily: "Vazir",
                      color: Color(0xff000000),
                      fontSize: 17,
                    ),
                  ),
                  content: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 15, right: 30),
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff000000),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Accordion(
                  title: Text(
                    "آذربایجان شرقی",
                    style: TextStyle(
                      fontFamily: "Vazir",
                      color: Color(0xff000000),
                      fontSize: 17,
                    ),
                  ),
                  content: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 15, right: 30),
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff000000),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "آذربایجان شرقی",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Themes.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "تایید",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: "Vazir",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}