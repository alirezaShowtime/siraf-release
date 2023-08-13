import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:siraf3/bloc/estate_bloc.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/map_utilities.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/estate.dart';
import 'package:siraf3/screens/estate_profile_without_comment/estate_profile_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class EstateScreen extends StatefulWidget {
  List<Estate> estates;
  City city;

  EstateScreen({required this.estates, required this.city, super.key});

  @override
  State<EstateScreen> createState() => _EstateScreenState();
}

class _EstateScreenState extends State<EstateScreen> with TickerProviderStateMixin {
  bool _showFileOnMyLocation = false;

  bool _firstTime = false;

  @override
  void initState() {
    super.initState();

    getEstates();
    setEstates();

    bloc.stream.listen((event) async {
      if (event is EstateLoadedState) {
        setState(() {
          currentSortType = event.sort_type;
        });

        estates = event.estates;

        if (mapEnabled) {
          if (_firstTime) {
            setState(() {
              _firstTime = false;
              Future.delayed(Duration(milliseconds: 500), () {
                _controller.move(myLocationMarker!.point, getZoomLevel(3000));
              });
            });
          } else {
            move(event);
          }
        }
      }
    });
  }

  List<Estate> estates = [];

  List<CircleMarker> circles = [];

  getEstates() {
    bloc.add(
      EstateLoadEvent(
        city_ids: [widget.city.id!],
        search: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
        latLng: (_showFileOnMyLocation && myLocationMarker != null) ? myLocationMarker!.point : null,
        sort: currentSortType,
      ),
    );
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
  void dispose() {
    super.dispose();

    bloc.close();
  }

  getEstatesFirstTime() async {
    if (await checkLocationEnabled()) {
      setState(() {
        _showFileOnMyLocation = true;
        _firstTime = true;
      });
      await _onMyLocationClicked(move: false);
    }

    getEstates();
  }

  checkLocationEnabled() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      return false;
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return false;
    }

    return true;
  }

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
              hintText: "جستجو در دفاتر املاک | " + widget.city.name!,
              hintStyle: TextStyle(color: Themes.textGrey, fontSize: 13),
              border: InputBorder.none,
            ),
            controller: _searchController,
            style: TextStyle(color: Themes.text, fontSize: 13),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              getEstates();
            },
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          actions: [
            if (!mapEnabled)
              MyPopupMenuButton(
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
                    MyPopupMenuItem<String>(
                      value: "newest",
                      label: "جدید ترین",
                      withSpace: true,
                      icon: currentSortType == "new" ? Icons.check_rounded : null,
                    ),
                    MyPopupMenuItem<String>(
                      value: "oldest",
                      label: "قدیمی ترین",
                      withSpace: true,
                      icon: currentSortType == "old" ? Icons.check_rounded : null,
                    ),
                    MyPopupMenuItem<String>(
                      value: "random",
                      label: "تصادفی",
                      withSpace: true,
                      icon: currentSortType == "random" ? Icons.check_rounded : null,
                    ),
                  ];
                },
                onSelected: (value) {
                  setState(() {
                    currentSortType = value;
                  });

                  getEstates();
                },
                iconData: CupertinoIcons.sort_down,
              ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  mapEnabled = !mapEnabled;
                });

                getEstates();
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
              child: BlocBuilder<EstateBloc, EstateState>(builder: _buildMainBloc),
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
            getEstates();
          },
        ),
      );
    }

    state = state as EstateLoadedState;

    if (state.estates.isEmpty) {
      notify("موردی پیدا نشد");
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
      _controller = MapController();
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FlutterMap(
                mapController: _controller,
                options: MapOptions(
                  center: defaultLocation,
                  interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                  zoom: 14.0,
                  onTap: (_, _1) {
                    // MapsLauncher.launchCoordinates(file.lat!, file.long!);
                    // launchUrl(Uri.parse('geo:0,0?q=${file.lat!},${file.long!}'));
                  },
                ),
                children: [
                  TileLayerWidget(
                    options: TileLayerOptions(
                      urlTemplate: "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=${MAPBOX_ACCESS_TOKEN}",
                    ),
                  ),
                  CircleLayerWidget(
                    options: CircleLayerOptions(
                      circles: circles,
                    ),
                  ),
                  MarkerLayerWidget(
                    options: MarkerLayerOptions(
                      markers: _buildEstateMarkers(state.estates),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Themes.background,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(-2, 2),
                      blurRadius: 4,
                    ),
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2, -2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(7),
                child: InkWell(
                  onTap: _onMyLocationClicked,
                  child: Center(
                    child: Icon(
                      Icons.my_location_outlined,
                      size: 30,
                      color: Themes.icon,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 80,
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    _showFileOnMyLocation = !_showFileOnMyLocation;
                  });
                  if (!_showFileOnMyLocation) {
                    setState(() {
                      circles.clear();
                    });

                    getEstates();
                    return;
                  }

                  await _onMyLocationClicked(move: false);

                  if (await checkLocationEnabled()) {
                    setState(() {
                      _showFileOnMyLocation = true;
                      _firstTime = true;
                    });

                    getEstates();
                  } else {
                    setState(() {
                      _showFileOnMyLocation = !_showFileOnMyLocation;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _showFileOnMyLocation ? Themes.primary : Themes.background,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(-2, 2),
                        blurRadius: 4,
                      ),
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(2, -2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "اطراف من",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "IranSansMedium",
                      color: _showFileOnMyLocation ? Themes.textLight : Themes.text,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Location _location = Location();
  Marker? myLocationMarker;
  MapController _controller = MapController();

  Future<bool> getLocationPermissions() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  Future<void> _onMyLocationClicked({bool move = true}) async {
    if (!await getLocationPermissions()) {
      notify("دسترسی موقعیت مکانی رد شده است لطفا به برنامه دسترسی بدهید");
      return;
    }

    notify("در حال دریافت موقعیت مکانی");

    LocationData locationData = await _location.getLocation();

    if (locationData.latitude == null || locationData.longitude == null || locationData.latitude == 0 || locationData.longitude == 0) {
      notify("موقعیت مکانی دریافت نشد");
      return;
    }

    var position = LatLng(locationData.latitude!, locationData.longitude!);

    setState(() {
      myLocationMarker = Marker(
        builder: _buildMapMarker,
        point: position,
      );
      if (move) _controller.move(position, getZoomLevel(1000));
    });

    if (_showFileOnMyLocation) {
      setState(() {
        circles = [
          CircleMarker(
            point: position,
            radius: 5,
            color: Colors.blue,
            borderStrokeWidth: 3,
            borderColor: Colors.white,
          ),
          CircleMarker(
            point: position,
            radius: 3000,
            useRadiusInMeter: true,
            color: Colors.blue.withOpacity(0.15),
            borderStrokeWidth: 0,
          )
        ];
      });
    }

    // if (points != null) setMarkersData(points!);
  }

  Widget _buildMapMarker(_) {
    return Image(
      image: AssetImage('assets/images/map_marker.png'),
      width: 30,
      height: 40,
      fit: BoxFit.contain,
    );
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
                  rating: estate.rate ?? 0.0,
                  // allowHalfRating: true,
                  // onRatingUpdate: (v) {},
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
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        detailsDialog = _;
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Themes.background,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
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
                                itemPadding: EdgeInsets.symmetric(horizontal: .2),
                                itemBuilder: (context, _) {
                                  return Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 10,
                                  );
                                },
                                rating: estate.rate ?? 0,
                                // allowHalfRating: true,
                                // onRatingUpdate: (v) {},
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
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  if (selectedEstates.where((element) => element.id == estate.id).isNotEmpty) {
                                    selectedEstates.removeWhere(
                                      (element) => element.id == estate.id,
                                    );
                                  } else {
                                    selectedEstates = selectedEstates + [estate];
                                  }
                                });

                                dismissDetailsDialog();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 50,
                              child: Text(
                                selectedEstates.where((element) => element.id == estate.id).isNotEmpty ? "حذف" : "افزودن",
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
                              onPressed: () {
                                push(
                                  context,
                                  EstateProfileScreen(
                                    estateId: estate.id!,
                                    estateName: estate.name,
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 50,
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

  _buildEstateMarkers(List<Estate> estates) {
    return estates
        .map<Marker>((e) => Marker(
              width: 240,
              height: 100,
              point: LatLng(double.parse(e.lat!), double.parse(e.long!)),
              builder: (_) {
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                itemPadding: EdgeInsets.symmetric(horizontal: .2),
                                itemBuilder: (context, _) {
                                  return Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 6,
                                  );
                                },
                                rating: e.rate ?? 0,
                                // onRatingUpdate: (double value) {},
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
                                borderRadius: BorderRadius.circular(20),
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
        .toList();
  }

  void move(EstateLoadedState state) {
    if (state.search) {
      if (estates.isNotEmpty) {
        animatedMapMove(_controller, toLatLng(estates[0].lat!, estates[0].long!), _controller.zoom, this);
      } else {
        animatedMapMove(_controller, toLatLng(widget.city.lat, widget.city.long!), 11, this);
      }
    } else if (estates.isNotEmpty) {
      var averageLat = average(
        estates.map<num>(
          (e) => num.parse(e.lat!),
        ),
      );
      var averageLng = average(
        estates.map<num>(
          (e) => num.parse(e.long!),
        ),
      );

      animatedMapMove(_controller, toLatLng(averageLat, averageLng), 12, this);
    } else {
      animatedMapMove(_controller, toLatLng(widget.city.lat, widget.city.long!), 11, this);
    }
  }

  LatLng toLatLng(lat, long) {
    return LatLng(toDouble(lat), toDouble(long));
  }

  double toDouble(value) {
    if (value is String) {
      return double.parse(value);
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is double) {
      return value;
    }

    return -1;
  }

  num average(Iterable<num> map) {
    num total = 0;

    map.forEach((element) {
      total += element;
    });

    return total / map.length;
  }
}

double getZoomLevel(double radius) {
  double zoomLevel = 11;
  if (radius > 0) {
    double radiusElevated = radius + radius / 2;
    double scale = radiusElevated / 500;
    zoomLevel = (16 - log(scale) / log(2)).toDouble();
  }
  zoomLevel = double.parse(zoomLevel.toStringAsFixed(2));
  return zoomLevel;
}
