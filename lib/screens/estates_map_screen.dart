import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:location/location.dart';
import 'package:siraf3/bloc/estate_bloc.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/estate.dart';
import 'package:siraf3/screens/agency_profile/agency_profile_screen.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:latlong2/latlong.dart';

import 'package:siraf3/dialog.dart';

class EstatesMapScreen extends StatefulWidget {
  EstatesMapScreen({super.key});

  @override
  State<EstatesMapScreen> createState() => _EstatesMapScreenState();
}

class _EstatesMapScreenState extends State<EstatesMapScreen> {
  List<City> cities = [];

  bool _showFileOnMyLocation = false;
  bool _firstTime = false;

  @override
  initState() {
    super.initState();

    getCities();
    getEstates();

    // getEstatesFirstTime();

    bloc.stream.listen((event) {
      if (event is EstateLoadedState) {
        if (_firstTime) {
          setState(() {
            _firstTime = false;
            _controller.move(myLocationMarker!.point, getZoomLevel(3000));
          });
        }
      }
    });
  }

  List<CircleMarker> circles = [];

  getCities() async {
    var mCities = await City.getList();
    setState(() {
      cities = mCities;
    });

    if (cities.isEmpty) {
      goSelectCity();
      return;
    }
  }

  getEstatesFirstTime() async {
    await getCities();
    if (await checkLocationEnabled()) {
      setState(() {
        _showFileOnMyLocation = true;
        _firstTime = true;
      });
      await _onMyLocationClicked(move: false);
    }

    getEstates();
  }

  getEstates() {
    bloc.add(
      EstateLoadEvent(
        city_ids: cities.map((e) => e.id!).toList(),
        search: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
        latLng: (_showFileOnMyLocation && myLocationMarker != null)
            ? myLocationMarker!.point
            : null,
      ),
    );
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

  EstateBloc bloc = EstateBloc();

  TextEditingController _searchController = TextEditingController();

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
              hintText: "جستجو در دفاتر املاک",
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
            GestureDetector(
              onTap: () async {
                goSelectCity();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 17,
                ),
                child: Text(
                  getTitle(cities),
                  style: TextStyle(
                    color: Themes.text,
                    fontSize: 14,
                    fontFamily: "IranSansMedium",
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                getEstates();
              },
              child: Icon(
                CupertinoIcons.search,
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
        body: BlocBuilder<EstateBloc, EstateState>(builder: _buildMainBloc),
      ),
    );
  }

  goSelectCity() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectCityScreen(
          showSelected: false,
          force: true,
          saveCity: false,
          selectedCities: cities,
        ),
      ),
    );

    if (result is List<City>) {
      setState(() {
        cities = result;
      });

      City.saveList(cities);

      await getCities();
      getEstates();
    }
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
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FlutterMap(
            mapController: _controller,
            options: MapOptions(
              center: defaultLocation,
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              zoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=${MAPBOX_ACCESS_TOKEN}",
              ),
              CircleLayer(
                circles: circles,
              ),
              MarkerLayer(
                markers: _buildEstateMarkers(state.estates),
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

              if (myLocationMarker == null) {
                await _onMyLocationClicked();
              }

              getEstates();
            },
            child: Container(
              decoration: BoxDecoration(
                color:
                    _showFileOnMyLocation ? Themes.primary : Themes.background,
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
    );
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

    LocationData locationData = await _location.getLocation();

    if (locationData.latitude == null ||
        locationData.longitude == null ||
        locationData.latitude == 0 ||
        locationData.longitude == 0) {
      notify("موقعیت مکانی دریافت نشد");
      return;
    }

    var position = LatLng(locationData.latitude!, locationData.longitude!);

    setState(() {
      myLocationMarker = Marker(
        builder: _buildMapMarker,
        point: position,
      );
      if (move) {
        _controller.move(position, getZoomLevel(3000));
      }
    });

    if (_showFileOnMyLocation) {
      setState(() {
        circles = [
          CircleMarker(
            point: position,
            radius: 8,
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

  BuildContext? detailsDialog;

  showDetailsDialog(Estate estate) {
    showDialog2(
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
                                // setState(() {
                                //   if (selectedEstates
                                //       .where(
                                //           (element) => element.id == estate.id)
                                //       .isNotEmpty) {
                                //     selectedEstates.removeWhere(
                                //       (element) => element.id == estate.id,
                                //     );
                                //   } else {
                                //     selectedEstates.add(estate);
                                //   }
                                // });

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
                                "سپردن فایل / درخواست",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AgencyProfileScreen(),
                                  ),
                                );
                              },
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
                                  fontSize: 12,
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
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: .2),
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

  String getTitle(List<City> cities) {
    return cities.isEmpty
        ? "انتخاب شهر"
        : cities.length == 1
            ? cities.first.name ?? "${cities.length} شهر"
            : "${cities.length} شهر";
  }

  void setLocationMarkers() {
    var position = myLocationMarker!.point;

    setState(() {
      myLocationMarker = Marker(
        builder: _buildMapMarker,
        point: position,
      );
      _controller.move(position, getZoomLevel(3000));
    });

    if (_showFileOnMyLocation) {
      setState(() {
        circles = [
          CircleMarker(
            point: position,
            radius: 8,
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