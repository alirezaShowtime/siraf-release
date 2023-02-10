import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/category.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/screens/select_category_screen.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/text_field_2.dart';

import '../../widgets/section.dart';

class RequestFileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RequestFileScreen();
}

class _RequestFileScreen extends State<RequestFileScreen> {
  Category? category;
  City? city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.background,
      appBar: AppBar(
        backgroundColor: Themes.appBar,
        leading: MyBackButton(),
        title: AppBarTitle("درخواست فایل"),
        automaticallyImplyLeading: false,
        elevation: 0.7,
        actions: [
          IconButton(onPressed: () {}, icon: icon(Icons.refresh_rounded))
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Themes.textGrey.withOpacity(0.5), width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "راهنما",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "IranSansMedium",
                          color: Themes.text,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 30,
                          ),
                          color: Colors.transparent,
                          alignment: Alignment.centerLeft,
                          child: icon(Icons.chevron_right_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "مشخصات کلی",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Themes.blue,
                  ),
                ),
                Section(
                  title: "دسته بندی",
                  hint: "انتخاب",
                  value: category?.name,
                  onTap: onClickCategoryItem,
                ),
                Section(
                  title: "شهر",
                  hint: "انتخاب",
                  value: city?.name,
                  onTap: onClickCityItem,
                ),
                Section(
                  title: "محدوده متراژ",
                  hint: "تعیین",
                  value: null,
                  onTap: onClickMeterageItem,
                ),
                Section(
                  title: "محدوده قیمت",
                  hint: "تعیین",
                  value: null,
                  onTap: onClickPriceItem,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 20),
                  child: TextField2(
                    decoration: InputDecoration(
                      labelText: 'عنوان',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextField2(
                    textAlignVertical: TextAlignVertical.top,
                    maxLines: 8,
                    //todo: label must be align top, change it
                    decoration: InputDecoration(
                      labelText: 'توضیحات',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
                Section(
                  title: "دفتر/دفاتر املاک(اخیتاری)",
                  hint: "انتخاب",
                  value: null,
                  onTap: onClickOfficeAgent,
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Themes.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: double.infinity,
                  child: Text(
                    "ثبت درخواست",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textButton(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Themes.blue,
      ),
    );
  }

  //event listeners
  void onClickCategoryItem() {
    //todo: implement event listener

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategorySelectScreen(filterIsAllCategories: true),
      ),
    ).then((result) {
      if (result != null || result is List<Category>) {
        setState(() {
          category = result.last;
        });
      }
    });
  }

  void onClickCityItem() {
    //todo: implement event listener

    Navigator.push(
            context, MaterialPageRoute(builder: (_) => SelectCityScreen()))
        .then((result) {
      if (result != null && result == List<City>) {
        city = result.last;
      }
    });
  }

  void onClickItem() {
    //todo: implement event listener
  }

  void onClickMeterageItem() {
    //todo: implement event listener
  }

  void onClickPriceItem() {
    //todo: implement event listener
  }

  void onClickGuideItem() {
    //todo: implement event listener
  }

  void onClickOfficeAgent() {
    //todo: implement event listener
  }
}
