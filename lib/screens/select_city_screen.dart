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
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:siraf3/widgets/usefull/button/button_primary.dart';
import 'package:siraf3/widgets/usefull/text/text_normal.dart';
import 'package:siraf3/widgets/usefull/text/text_title.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class SelectCityScreen extends StatefulWidget {
  bool showSelected;
  bool saveCity;
  int? max;
  bool force;
  List<City>? selectedCities;

  SelectCityScreen({
    super.key,
    this.showSelected = false,
    this.saveCity = true,
    this.force = false,
    this.max = null,
    this.selectedCities,
  });

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  late GetCitiesBloc bloc;

  GetCitiesState currentState = GetCitiesInitialState();

  bool onSearching = false;
  TextEditingController _searchFieldCtrl = TextEditingController();

  List<Province> provinces = [];
  List<Province> allProvinces = [];
  List<City> selectedCities = [];

  @override
  void initState() {
    super.initState();

    bloc = BlocProvider.of<GetCitiesBloc>(context);

    bloc.stream.listen((event) {
      _onCitiesEvent(event);
    });

    getCities();

    getCurrentCityName();

    if (widget.showSelected || (widget.selectedCities?.isNotEmpty ?? false)) showSelectedCities();
  }

  showSelectedCities() async {
    List<City> cities = [];
    if (widget.selectedCities?.isNotEmpty ?? false) {
      cities = widget.selectedCities!;
    } else {
      cities = await City.getList();
    }

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

  getCurrentCityName() async {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        backgroundColor: Themes.background,
        appBar: AppBar(
          backgroundColor: Themes.appBar,
          shadowColor: Color(0x50000000),
          elevation: 0.7,
          actions: !onSearching
              ? [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectedCities = [];
                      });
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
                ]
              : [],
          title: !onSearching
              ? TextTitle("انتخاب شهر")
              : TextField2(
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
            onPressed: () async {
              if (await _handleBack()) {
                Navigator.pop(context);
              }
            },
            icon: Icon(
              CupertinoIcons.back,
              color: Themes.icon,
              size: 20,
            ),
          ),
        ),
        body: getContentWidget(currentState),
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
        return province.cities.where((City city) => regExp.hasMatch(city.name ?? "")).isNotEmpty;
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
        cities += element.cities.where((City city) => regExp.hasMatch(city.name ?? "")).toList();
      });
    }

    TextFormField();

    bloc.add(GetCitiesEmitState(state: GetCitiesLoadedState(cities: cities, searching: true)));
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
                cities: cities.where((element) => element.parentId == e.id).toList(),
              ))
          .toList();

      if (!(state as GetCitiesLoadedState).searching) {
        allProvinces = provinces;
      }
    });
  }

  _onTapSubmit() async {
    if (widget.force && selectedCities.isEmpty) return notify("شهری انتخاب نکرده اید");

    if (widget.saveCity) {
      await City.saveList(selectedCities);

      await (await SharedPreferences.getInstance()).setBool("isFirstOpen", false);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
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
      return Stack(
        children: [
          ListView(
            children: <Widget>[
                  if (selectedCities.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        child: Row(
                          children: selectedCities
                              .map<Widget>(
                                (e) => Padding(
                                    padding: EdgeInsets.only(
                                      right: selectedCities.first == e ? 10 : 5,
                                      left: selectedCities.last == e ? 10 : 0,
                                    ),
                                    child: _createSelectedCityBadge(e)),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  _myLocationSection(),
                  SizedBox(
                    height: 5,
                  ),
                ] +
                provinces.map<Widget>((e) {
                  return _accordionItem(e);
                }).toList() +
                [
                  SizedBox(height: 60),
                ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ButtonPrimary(
                onPressed: _onTapSubmit,
                text: "تایید",
                fullWidth: true,
              ),
            ),
          )
        ],
      );
    }

    return Container();
  }

  int currentCityAccordion = -1;

  _createSelectedCityBadge(City e) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCities.removeWhere((el) => el.id == e.id);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
        decoration: BoxDecoration(
          color: Color(0xfffdb713),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          TextNormal(
            e.name!,
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Typicons.delete_outline,
            color: Themes.icon,
            size: 22,
          ),
        ]),
      ),
    );
  }

  Widget _accordionItem(Province e) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Accordion(
        title: TextNormal(
          e.name,
          color: Colors.black,
        ),
        open: currentCityAccordion == e.id,
        onClick: () {
          setState(() {
            currentCityAccordion = currentCityAccordion == e.id ? -1 : e.id;
          });
          print(currentCityAccordion);
        },
        content: Container(
          padding: EdgeInsets.only(top: 10, bottom: 15, right: 20),
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: e.cities.map<Widget>((e) {
              return _accordionCityItem(e);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _accordionCityItem(City e) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedCities.any((element) => element.id == e.id)) {
            selectedCities.removeWhere((el) => el.id == e.id);
          } else {
            if (widget.max != null && selectedCities.length == widget.max) {
              notify("حداکثر " + widget.max.toString() + " شهر میتوانید انتخاب کنید");
            } else {
              selectedCities.add(e);
            }
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            TextNormal(
              e.name!,
              fontFamily: selectedCities.any((element) => element.id == e.id) ? "IranSansMedium" : "IranSans",
              color: selectedCities.any((element) => element.id == e.id) ? Themes.primary : Themes.textGrey,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _handleBack() async {
    if (onSearching) {
      setState(() {
        _searchFieldCtrl.clear();
        doSearch("");
        onSearching = false;
      });
      return false;
    }

    return true;
  }

  Widget _myLocationSection() {
    return Container(
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
    );
  }
}
