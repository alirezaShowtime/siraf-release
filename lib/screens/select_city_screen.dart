import 'package:flutter/cupertino.dart';
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
import 'package:siraf3/widgets/try_again.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class SelectCityScreen extends StatefulWidget {
  bool showSelected;
  bool saveCity;
  int? max;
  bool force;

  SelectCityScreen({
    super.key,
    this.showSelected = false,
    this.saveCity = true,
    this.force = false,
    this.max = null,
  });

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
        backgroundColor: Themes.background,
        appBar: onSearching
            ? AppBar(
                backgroundColor: Themes.appBar,
                elevation: 0.7,
                title: TextField2(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "جستجو در شهر ها",
                    hintStyle: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  style: TextStyle(fontSize: 15),
                  controller: _searchFieldCtrl,
                  onChanged: ((value) {
                    doSearch(value.trim());
                  }),
                ),
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                leading: IconButton(
                  onPressed: () {
                    setState(() {
                      _searchFieldCtrl.clear();
                      doSearch("");
                      onSearching = false;
                    });
                  },
                  icon: Icon(
                    CupertinoIcons.back,
                    color: Themes.icon,
                    size: 20,
                  ),
                ),
              )
            : AppBar(
                backgroundColor: Themes.appBar,
                shadowColor: Color(0x50000000),
                elevation: 0.7,
                actions: [
                  IconButton(
                    onPressed: () {
                      getCities();
                    },
                    icon: Icon(
                      CupertinoIcons.refresh,
                      color: Themes.icon,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        onSearching = true;
                      });
                    },
                    icon: Icon(
                      CupertinoIcons.search,
                      color: Themes.icon,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
                title: Text(
                  "انتخاب شهر",
                  style: TextStyle(
                    color: Themes.text,
                    fontFamily: "IranSansMedium",
                    fontSize: 15,
                  ),
                ),
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    CupertinoIcons.back,
                    color: Themes.icon,
                    size: 20,
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
                                color: Color(0xff000000),
                                fontSize: 16,
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
                                Typicons.delete_outline,
                                color: Color(0xff707070),
                                size: 22,
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
                  Icon(
                    Typicons.location_outline,
                    color: Themes.secondary,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "انتخاب لوکیشن فعلی من (",
                          style: TextStyle(
                            color: Themes.text,
                            fontSize: 15,
                            fontFamily: "IranSansMedium",
                          ),
                        ),
                        TextSpan(
                          text: "تهران",
                          style: TextStyle(
                            color: Themes.secondary,
                            fontSize: 15,
                            fontFamily: "IranSansMedium",
                          ),
                        ),
                        TextSpan(
                          text: ")",
                          style: TextStyle(
                            color: Themes.text,
                            fontSize: 15,
                            fontFamily: "IranSansMedium",
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: getContentWidget(currentState),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: RawMaterialButton(
                onPressed: _onTapSubmit,
                child: Text(
                  "تایید",
                  style: TextStyle(
                    color: Themes.textLight,
                    fontSize: 17,
                    fontFamily: "IranSansMedium",
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
    if (widget.force && selectedCities.isEmpty)
      return notify("شهری انتخاب نکرده اید");

    if (widget.saveCity) {
      await City.saveList(selectedCities);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      Navigator.pop(context, selectedCities);
    }
  }

  Widget getContentWidget(GetCitiesState state) {
    if (state is GetCitiesInitialState || state is GetCitiesLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is GetCitiesErrorState) {
      return Center(
        child: TryAgain(
          onPressed: getCities,
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
              color: Color(0xff000000),
              fontSize: 15,
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
                        } else {
                          if (widget.max != null &&
                              selectedCities.length == widget.max) {
                            notify("حداکثر " +
                                widget.max.toString() +
                                " شهر میتوانید انتخاب کنید");
                          } else {
                            selectedCities.add(e);
                          }
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          e.name!,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: selectedCities.asMap().containsValue(e)
                                ? Color(0xff3d3d3d)
                                : Color(0xff707070),
                            fontSize: 15,
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
