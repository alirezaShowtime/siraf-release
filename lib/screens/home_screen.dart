import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/file_slide_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    checkIsCitySelected();
  }

  List<City> cities = [];

  checkIsCitySelected() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getBool("isFirstOpen") ?? true) {
      await sharedPreferences.setBool("isFirstOpen", false);
      goSelectCity();
    } else {
      var mCities = await City.getList();
      setState(() {
        cities = mCities;
      });
    }
  }

  goSelectCity({showSelected = false}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SelectCityScreen(showSelected: showSelected)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: GestureDetector(
          onTap: () => goSelectCity(showSelected: true),
          child: Container(
            color: Themes.appBar,
            padding: const EdgeInsets.all(10),
            child: Text(
              getTitle(cities),
              style: TextStyle(
                color: Themes.text,
                fontSize: 14,
              ),
            ),
          ),
        ),
        backgroundColor: Themes.appBar,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
            onPressed: () {},
            icon: Image(
              image: AssetImage("assets/images/ic_menu.png"),
              width: 30,
              height: 30,
              color: Themes.primary,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image(
              image: AssetImage("assets/images/ic_filter.png"),
              width: 24,
              height: 24,
              color: Themes.primary,
            ),
          ),
          IconButton(
            onPressed: () {},
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
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 5,
          ),
          FileHorizontalItem(),
          SizedBox(
            height: 5,
          ),
          FileSlideItem(),
          SizedBox(
            height: 5,
          ),
          FileSlideItem(),
          SizedBox(
            height: 5,
          ),
          FileHorizontalItem(),
          SizedBox(
            height: 5,
          ),
          FileHorizontalItem(),
          SizedBox(
            height: 5,
          ),
          FileHorizontalItem(),
          SizedBox(
            height: 5,
          ),
          FileHorizontalItem()
        ],
      ),
    );
  }

  String getTitle(List<City> cities) {
    return cities.isEmpty
        ? "انتخاب شهر"
        : cities.length == 1
            ? cities.first.name ?? "${cities.length} شهر"
            : "${cities.length} شهر";
  }
}
