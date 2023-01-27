import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:siraf3/bloc/estate_bloc.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/estate.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:latlong2/latlong.dart';

class EstateScreen extends StatefulWidget {
  List<Estate> estates;

  EstateScreen({required this.estates, super.key});

  @override
  State<EstateScreen> createState() => _EstateScreenState();
}

class _EstateScreenState extends State<EstateScreen> {
  List<City> cities = [];

  @override
  void initState() {
    super.initState();

    getCities();
    setEstates();

    bloc.stream.listen((event) {
      if (event is EstateLoadedState) {
        setState(() {
          currentSortType = event.sort_type;
        });
      }
    });
  }

  getCities() async {
    var mCities = await City.getList();
    setState(() {
      cities = mCities;
    });

    bloc.add(EstateLoadEvent(city_ids: cities.map((e) => e.id!).toList()));
  }

  setEstates() {
    setState(() {
      selectedEstates = widget.estates;
    });
  }

  String? currentSortType;

  List<Estate> selectedEstates = [];

  EstateBloc bloc = EstateBloc();

  TextEditingController _searchController = TextEditingController();

  bool mapEnabled = false;

  LatLng defaultLocation = LatLng(34.08892074204623, 49.7009108491914);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Themes.appBar,
          elevation: 0.7,
          title: TextField2(
            decoration: InputDecoration(
              hintText: "جستجو در دفاتر املاک | " +
                  cities.map((e) => e.name).join(' و '),
              hintStyle: TextStyle(color: Themes.textGrey, fontSize: 13),
              border: InputBorder.none,
            ),
            controller: _searchController,
            style: TextStyle(color: Themes.text, fontSize: 13),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              bloc.add(EstateLoadEvent(
                  city_ids: cities.map((e) => e.id!).toList(), search: value));
            },
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          actions: [
            GestureDetector(
              onTap: () {
                bloc.add(EstateLoadEvent(
                    city_ids: cities.map((e) => e.id!).toList(),
                    search: _searchController.text));
              },
              child: Icon(
                CupertinoIcons.search,
                color: Themes.icon,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            if (!mapEnabled)
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<String>(
                      value: "alphabet",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "بر اساس حروف الفبا",
                            style: TextStyle(
                              fontSize: 13,
                              color: Themes.text,
                            ),
                          ),
                          if (currentSortType == "alphabet")
                            Icon(
                              Icons.check,
                              color: Themes.icon,
                              size: 20,
                            ),
                        ],
                      ),
                      height: 35,
                    ),
                    PopupMenuItem<String>(
                      value: "topRate",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "بالاترین امتیاز",
                            style: TextStyle(
                              fontSize: 13,
                              color: Themes.text,
                            ),
                          ),
                          if (currentSortType == "topRate")
                            Icon(
                              Icons.check,
                              color: Themes.icon,
                              size: 20,
                            ),
                        ],
                      ),
                      height: 35,
                    ),
                    PopupMenuItem<String>(
                      value: "new",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "جدید ترین",
                            style: TextStyle(
                              fontSize: 13,
                              color: Themes.text,
                            ),
                          ),
                          if (currentSortType == "new")
                            Icon(
                              Icons.check,
                              color: Themes.icon,
                              size: 20,
                            ),
                        ],
                      ),
                      height: 35,
                    ),
                    PopupMenuItem<String>(
                      value: "old",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "قدیمی ترین",
                            style: TextStyle(
                              fontSize: 13,
                              color: Themes.text,
                            ),
                          ),
                          if (currentSortType == "old")
                            Icon(
                              Icons.check,
                              color: Themes.icon,
                              size: 20,
                            ),
                        ],
                      ),
                      height: 35,
                    ),
                    PopupMenuItem<String>(
                      value: "random",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "تصادفی",
                            style: TextStyle(
                              fontSize: 13,
                              color: Themes.text,
                            ),
                          ),
                          if (currentSortType == "random")
                            Icon(
                              Icons.check,
                              color: Themes.icon,
                              size: 20,
                            ),
                        ],
                      ),
                      height: 35,
                    ),
                  ];
                },
                onSelected: (String? value) {
                  bloc.add(
                    EstateLoadEvent(
                      city_ids: cities.map((e) => e.id!).toList(),
                      search: _searchController.text,
                      sort: value,
                    ),
                  );
                },
                icon: Icon(
                  CupertinoIcons.sort_down,
                  color: Themes.icon,
                ),
              ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  mapEnabled = !mapEnabled;
                });

                bloc.add(EstateLoadEvent(
                    city_ids: cities.map((e) => e.id!).toList(),
                    search: _searchController.text));
              },
              child: Icon(
                mapEnabled ? CupertinoIcons.map_fill : CupertinoIcons.map,
                color: Themes.icon,
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.back,
              color: Themes.icon,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child:
                  BlocBuilder<EstateBloc, EstateState>(builder: _buildMainBloc),
            ),
            if (selectedEstates.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: selectedEstates.map<Widget>((e) {
                      return Container(
                        child: Row(children: [
                          Text(
                            e.name!,
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedEstates.remove(e);
                              });
                            },
                            child: Icon(
                              Typicons.delete_outline,
                              color: Color(0xff707070),
                              size: 22,
                            ),
                          )
                        ]),
                      );
                    }).toList()),
                  ),
                ),
              ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          selectedEstates,
                        );
                      },
                      color: Themes.primary,
                      child: Text(
                        "تایید",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minWidth: 100,
                      height: 45,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainBloc(BuildContext context, EstateState state) {
    if (state is EstateInitState || state is EstateLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is EstateErrorState) {
      return Center(
        child: TryAgain(
          onPressed: () {
            bloc.add(
              EstateLoadEvent(
                city_ids: cities.map((e) => e.id!).toList(),
                search: _searchController.text,
              ),
            );
          },
        ),
      );
    }

    state = state as EstateLoadedState;

    if (state.estates.isEmpty) {
      return Center(
        child: Text(
          "متاسفانه موردی پیدا نشد",
          style: TextStyle(
            fontSize: 15,
            color: Themes.text,
          ),
        ),
      );
    }

    if (!mapEnabled) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: state.estates.map<Widget>((e) => buildItem(e)).toList(),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FlutterMap(
            options: MapOptions(
              center: defaultLocation,
              zoom: 13.0,
              onTap: (_, _1) {
                // MapsLauncher.launchCoordinates(file.lat!, file.long!);
                // launchUrl(Uri.parse('geo:0,0?q=${file.lat!},${file.long!}'));
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=${MAPBOX_ACCESS_TOKEN}",
              ),
              MarkerLayer(
                markers: state.estates
                    .map<Marker>((e) => Marker(
                          width: 240,
                          height: 100,
                          point: LatLng(
                              double.parse(e.lat!), double.parse(e.long!)),
                          builder: (_) {
                            // return Icon(
                            //   Typicons.location,
                            //   color: Colors.red,
                            // );
                            return GestureDetector(
                              onTap: () {
                                showDetailsDialog(e);
                              },
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 30,
                                    child: Container(
                                      height: 60,
                                      width: 122,
                                      decoration: BoxDecoration(
                                        color: Color(0xff707070),
                                        border: Border.all(
                                          color: Themes.icon,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            e.name!,
                                            style: TextStyle(
                                              color: Themes.textLight,
                                              fontSize: 11,
                                            ),
                                          ),
                                          Text(
                                            "مدیریت : ${e.managerName}",
                                            style: TextStyle(
                                              color: Themes.textLight,
                                              fontSize: 8,
                                            ),
                                          ),
                                          RatingBarIndicator(
                                            direction: Axis.horizontal,
                                            itemCount: 5,
                                            itemSize: 14,
                                            unratedColor: Colors.grey,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: .2),
                                            itemBuilder: (context, _) {
                                              return Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 6,
                                              );
                                            },
                                            rating: e.rate ?? 5.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 100,
                                    width: 240,
                                    alignment: Alignment.center,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Typicons.location,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          width: 20,
                                          height: 20,
                                        ),
                                        Icon(
                                          Typicons.location_outline,
                                          size: 40,
                                          color: Themes.icon,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ))
                    .toList(),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget buildItem(Estate estate) {
    return GestureDetector(
      onTap: () {
        showDetailsDialog(estate);
      },
      child: Padding(
        padding: EdgeInsets.only(top: 5),
        child: Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: RatingBarIndicator(
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 14,
                  unratedColor: Colors.grey,
                  itemPadding: EdgeInsets.symmetric(horizontal: .2),
                  itemBuilder: (context, _) {
                    return Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 10,
                    );
                  },
                  rating: 4.2,
                ),
              ),
              Text(
                estate.name! + " | " + estate.address!,
                style: TextStyle(
                  fontSize: 11.5,
                  fontFamily: "IranSansMedium",
                  color: Themes.text,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "مدریت : " + estate.managerName!,
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: "IranSansMedium",
                  color: Themes.textGrey,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                height: 0.7,
                color: Themes.textGrey.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BuildContext? detailsDialog;

  showDetailsDialog(Estate estate) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        detailsDialog = _;
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Themes.background,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Wrap(
              children: [
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                estate.name!,
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 14,
                                ),
                              ),
                              RatingBarIndicator(
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 14,
                                unratedColor: Colors.grey,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: .2),
                                itemBuilder: (context, _) {
                                  return Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 10,
                                  );
                                },
                                rating: 4.2,
                              ),
                            ],
                          ),
                          SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "مدیریت : " + estate.managerName!,
                                style: TextStyle(
                                  color: Themes.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "امتیار 4/4 از 5",
                                style: TextStyle(
                                  color: Themes.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "موبایل : " + estate.phoneNumber!,
                                style: TextStyle(
                                  color: Themes.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "تلفن : " + "02133333333",
                                style: TextStyle(
                                  color: Themes.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 7),
                          Text(
                            "آدرس : " + estate.address!,
                            style: TextStyle(
                              color: Themes.textGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  if (selectedEstates
                                      .where(
                                          (element) => element.id == estate.id)
                                      .isNotEmpty) {
                                    selectedEstates.removeWhere(
                                      (element) => element.id == estate.id,
                                    );
                                  } else {
                                    selectedEstates.add(estate);
                                  }
                                });

                                dismissDetailsDialog();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                selectedEstates
                                        .where((element) =>
                                            element.id == estate.id)
                                        .isNotEmpty
                                    ? "حذف"
                                    : "افزودن",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: "IranSansBold",
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 9),
                            ),
                          ),
                          SizedBox(
                            width: 0.5,
                          ),
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "مشاهده پروفایل",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: "IranSansBold",
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  dismissDetailsDialog() {
    if (detailsDialog != null) {
      Navigator.pop(detailsDialog!);
    }
  }
}
