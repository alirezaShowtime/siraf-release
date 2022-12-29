import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/bloc/get_cities_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/province.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/accordion.dart';
import 'package:siraf3/widgets/icon_asset.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class SelectCityScreen extends StatefulWidget {
  bool showSelected;

  SelectCityScreen({super.key, this.showSelected = false});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  bool onSearching = false;

  List<Province> provinces = [];
  List<Province> allProvinces = [];
  List<City> selectedCities = [];

  late GetCitiesBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = BlocProvider.of<GetCitiesBloc>(context);

    bloc.stream.listen((event) {
      _onCitiesEvent(event);
    });

    getCities();

    getCurrentCityName();

    if (widget.showSelected) showSelectedCities();
  }

  showSelectedCities() async {
    var cities = await City.getList();

    setState(() {
      this.selectedCities = cities;
    });
  }

  getCities() {
    setState(() {
      selectedCities.clear();
      provinces.clear();
    });
    bloc.add(GetCitiesEvent());
  }

  GetCitiesState currentState = GetCitiesInitialState();

  getCurrentCityName() async {}

  TextEditingController _searchFieldCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (onSearching) {
          setState(() {
            onSearching = false;
          });
          return false;
        }

        return true;
      },
      child: Scaffold(
        backgroundColor: Themes.background2,
        appBar: onSearching
            ? AppBar(
                backgroundColor: Color(0xffffffff),
                shadowColor: Color(0x50000000),
                actions: [
                  // IconButton(
                  //   onPressed: () {
                  //     if (_searchFieldCtrl.text.trim().isNotEmpty) {
                  //       doSearch(_searchFieldCtrl.text.trim());
                  //     }
                  //     setState(() {
                  //       onSearching = false;
                  //     });
                  //   },
                  //   icon: Image(
                  //     image: AssetImage("assets/images/ic_search.png"),
                  //     width: 24,
                  //     height: 24,
                  //     color: Themes.primary,
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                ],
                title: TextField2(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "جستجو در شهر ها",
                    hintStyle: TextStyle(fontSize: 17, fontFamily: "Vazir"),
                  ),
                  style: TextStyle(fontSize: 17, fontFamily: "Vazir"),
                  controller: _searchFieldCtrl,
                  onChanged: ((value) {
                    doSearch(value.trim());
                  }),
                ),
                leading: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _searchFieldCtrl.clear();
                        doSearch("");
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
                    onPressed: () {
                      getCities();
                    },
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
            if (selectedCities.isNotEmpty &&
                currentState is GetCitiesLoadedState)
              SizedBox(
                height: 10,
              ),
            if (selectedCities.isNotEmpty &&
                currentState is GetCitiesLoadedState)
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
            if (currentState is GetCitiesLoadedState)
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
                child: getContentWidget(currentState),
              ),
            ),
            // Container(
            //   height: 60,
            //   width: double.infinity,
            //   margin: EdgeInsets.all(10),
            //   decoration: BoxDecoration(
            //     color: Themes.primary,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: GestureDetector(
            //     onTap: _onTapSubmit(),
            //     child: Center(
            //       child: Text(
            //         "تایید",
            // style: TextStyle(
            //   color: Colors.white,
            //   fontSize: 17,
            //   fontFamily: "Vazir",
            // ),
            //       ),
            //     ),
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: RawMaterialButton(
                onPressed: _onTapSubmit,
                child: Text(
                  "تایید",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: "Vazir",
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                constraints: BoxConstraints(
                  minHeight: 60,
                  minWidth: double.infinity,
                ),
                fillColor: Themes.primary,
              ),
            )
          ],
        ),
      ),
    );
  }

  doSearch(String q) async {
    bloc.add(GetCitiesEmitState(state: GetCitiesLoadingState()));

    await Future.delayed(Duration(milliseconds: 500));

    RegExp regExp = new RegExp(
      r".*(" + q + ").*",
      caseSensitive: false,
      multiLine: false,
    );

    var cities = <City>[];
    var p = allProvinces;

    if (q.isEmpty) {
      cities = p
          .map<City>((Province e) => City(
                id: e.id,
                countFile: e.countFile,
                name: e.name,
                parentId: e.parentId,
                weight: e.weight,
              ))
          .toList();

      p.forEach((element) {
        cities += element.cities;
      });
    } else {
      p = p.where((Province province) {
        return province.cities
            .where((City city) => regExp.hasMatch(city.name ?? ""))
            .isNotEmpty;
      }).toList();

      cities = p
          .map<City>((Province e) => City(
                id: e.id,
                countFile: e.countFile,
                name: e.name,
                parentId: e.parentId,
                weight: e.weight,
              ))
          .toList();

      p.forEach((element) {
        cities += element.cities
            .where((City city) => regExp.hasMatch(city.name ?? ""))
            .toList();
      });
    }

    TextFormField();

    bloc.add(GetCitiesEmitState(
        state: GetCitiesLoadedState(cities: cities, searching: true)));
  }

  _onCitiesEvent(GetCitiesState state) {
    setState(() {
      currentState = state;
    });

    if (state is GetCitiesInitialState || state is GetCitiesLoadingState) {
      return;
    }

    if (state is GetCitiesErrorState) {
      return;
    }

    state = state as GetCitiesLoadedState;

    var cities = state.cities;

    setState(() {
      provinces = cities
          .where((element) => element.parentId == null)
          .map<Province>((City e) => Province(
                id: e.id!,
                name: e.name!,
                countFile: e.countFile,
                parentId: e.parentId,
                weight: e.weight,
                cities: cities
                    .where((element) => element.parentId == e.id)
                    .toList(),
              ))
          .toList();

      if (!(state as GetCitiesLoadedState).searching) {
        allProvinces = provinces;
      }
    });
  }

  _onTapSubmit() async {
    await City.saveList(selectedCities);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  Widget getContentWidget(GetCitiesState state) {
    if (state is GetCitiesInitialState || state is GetCitiesLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is GetCitiesErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("خطایی در هنگام دریافت اطلاعات پیش آمد"),
            SizedBox(
              height: 10,
            ),
            RawMaterialButton(
              onPressed: getCities,
              child: Text(
                "تلاش مجدد",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              fillColor: Themes.primary,
            )
          ],
        ),
      );
    }

    if (state is GetCitiesLoadedState) {
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
                        if (selectedCities.asMap().containsValue(e)) {
                          selectedCities.remove(e);
                        } else
                          selectedCities.add(e);
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          e.name!,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Vazir",
                            color: selectedCities.asMap().containsValue(e)
                                ? Color(0xff3d3d3d)
                                : Color(0xff707070),
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }).toList());
    }

    return Container();
  }
}
