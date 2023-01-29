import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/text_field_2.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Image(
              image: AssetImage("assets/images/filter_background.png"),
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                  tileMode: TileMode.clamp,
                  begin: Alignment(0, -1),
                  end: Alignment(0, 0),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              CupertinoIcons.back,
                              color: Themes.iconLight,
                              size: 20,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              right: 5,
                              bottom: 10,
                            ),
                            child: Text(
                              "فیلتر",
                              style: TextStyle(
                                  color: Themes.textLight, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          left: 10,
                          bottom: 10,
                        ),
                        child: Text(
                          "حذف همه",
                          style:
                              TextStyle(color: Themes.textLight, fontSize: 13),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Wrap(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(-1, 0),
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                                BoxShadow(
                                  offset: Offset(1, 0),
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                                BoxShadow(
                                  offset: Offset(1, 1),
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                                BoxShadow(
                                  offset: Offset(-1, -1),
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ]),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 7,
                                      bottom: 7,
                                      left: 5,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Themes.primary,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "فروشی",
                                        style: TextStyle(
                                          color: Themes.textLight,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 7,
                                      bottom: 7,
                                      left: 5,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Colors.transparent,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "اجاره ای",
                                        style: TextStyle(
                                          color: Themes.text,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 7,
                                      bottom: 7,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Colors.transparent,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "ساخت و ساز",
                                        style: TextStyle(
                                          color: Themes.text,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(-1, 0),
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                offset: Offset(1, 0),
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                offset: Offset(0, 0),
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                offset: Offset(1, 1),
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                offset: Offset(-1, -1),
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "همه",
                                            style: TextStyle(
                                              color: Themes.secondary2,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Divider(
                                            color: Themes.secondary2,
                                            height: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "همه",
                                            style: TextStyle(
                                              color: Themes.secondary2,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Divider(
                                            color: Themes.secondary2
                                                .withOpacity(0.5),
                                            height: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "همه",
                                            style: TextStyle(
                                              color: Themes.secondary2,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Divider(
                                            color: Themes.secondary2
                                                .withOpacity(0.5),
                                            height: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "همه",
                                            style: TextStyle(
                                              color: Themes.secondary2,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Divider(
                                            color: Themes.secondary2
                                                .withOpacity(0.5),
                                            height: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "قیمت",
                                      style: TextStyle(
                                        color: Themes.secondary2,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      "(تومان)",
                                      style: TextStyle(
                                        color: Themes.secondary2,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 40,
                                        child: TextField2(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              borderSide: BorderSide(
                                                color: Themes.secondary2,
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              borderSide: BorderSide(
                                                color: Themes.secondary2,
                                                width: 2,
                                              ),
                                            ),
                                            hintText: "حداقل",
                                            hintStyle: TextStyle(
                                              fontSize: 13,
                                              color: Themes.textGrey,
                                            ),
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Themes.text,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 40,
                                        child: TextField2(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              borderSide: BorderSide(
                                                color: Themes.secondary2,
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              borderSide: BorderSide(
                                                color: Themes.secondary2,
                                                width: 2,
                                              ),
                                            ),
                                            hintText: "حداکثر",
                                            hintStyle: TextStyle(
                                              fontSize: 13,
                                              color: Themes.textGrey,
                                            ),
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Themes.text,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "متراژ",
                                  style: TextStyle(
                                    color: Themes.secondary2,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 40,
                                        child: TextField2(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              borderSide: BorderSide(
                                                color: Themes.secondary2,
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              borderSide: BorderSide(
                                                color: Themes.secondary2,
                                                width: 2,
                                              ),
                                            ),
                                            hintText: "حداقل",
                                            hintStyle: TextStyle(
                                              fontSize: 13,
                                              color: Themes.textGrey,
                                            ),
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Themes.text,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 40,
                                        child: TextField2(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              borderSide: BorderSide(
                                                color: Themes.secondary2,
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              borderSide: BorderSide(
                                                color: Themes.secondary2,
                                                width: 2,
                                              ),
                                            ),
                                            hintText: "حداکثر",
                                            hintStyle: TextStyle(
                                              fontSize: 13,
                                              color: Themes.textGrey,
                                            ),
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Themes.text,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "امکانات تصویری فایل",
                                  style: TextStyle(
                                    color: Themes.secondary2,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Themes.secondary2,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "عکس دار",
                                            style: TextStyle(
                                              color: Themes.textLight,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Themes.secondary2,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "ویدیو دار",
                                            style: TextStyle(
                                              color: Themes.textLight,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Themes.secondary2,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "تور مجازی",
                                            style: TextStyle(
                                              color: Themes.textLight,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Themes.primary,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "اعمال فیلتر",
                                  style: TextStyle(
                                    color: Themes.textLight,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
}
