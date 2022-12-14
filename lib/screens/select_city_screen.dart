import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:siraf3/bloc/get_cities_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/province.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/accordion.dart';
import 'package:siraf3/widgets/icon_asset.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({super.key});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  bool onSearching = false;

  List<Province> provinces = [];
  List<City> selectedCities = [];

  @override
  void initState() {
    super.initState();

    getCities();

    getCurrentCityName();
  }

  getCities() {
    BlocProvider.of<GetCitiesBloc>(context).add(GetCitiesEvent());
  }

  getCurrentCityName() async {}

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
          if (selectedCities.isNotEmpty)
            SizedBox(
              height: 10,
            ),
          if (selectedCities.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: selectedCities
                    .map<Widget>(
                      (e) => Container(
                        child: Row(children: [
                          Text(
                            e.name!,
                            style: TextStyle(
                              fontFamily: "Vazir",
                              color: Color(0xff000000),
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCities.remove(e);
                              });
                            },
                            child: Icon(
                              Typicons.delete,
                              color: Color(0xff707070),
                              size: 26,
                            ),
                          )
                        ]),
                      ),
                    )
                    .toList(),
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
              child: BlocBuilder<GetCitiesBloc, GetCitiesState>(
                  builder: _buildCitiesState),
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

  Widget _buildCitiesState(BuildContext context, GetCitiesState state) {
    if (state is GetCitiesInitialState || state is GetCitiesLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is GetCitiesErrorState) {
      notify("خطایی در هنگام دریافت اطلاعات پیش آمد");
      return Center();
    }

    state = state as GetCitiesLoadedState;

    var cities = state.cities;

    provinces = cities
        .where((element) => element.parentId == null)
        .map<Province>((e) => Province(
              id: e.id!,
              name: e.name!,
              cities: cities.where((element) => element.parentId == e.id).toList(),
            ))
        .toList();

    return ListView(
        children: provinces.map<Widget>((e) {
      return Accordion(
        title: Text(
          e.name,
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
            children: e.cities.map<Widget>((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCities.add(e);
                    });
                  },
                  child: Text(
                    e.name!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: "Vazir",
                      color: Color(0xff707070),
                      fontSize: 17,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }).toList());
  }
}
