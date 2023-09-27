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
import 'package:siraf3/main.dart';
import 'package:siraf3/map_utilities.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/estate.dart';
import 'package:siraf3/screens/create/create_file_first.dart';
import 'package:siraf3/screens/request_file/request_file_screen.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/static_star.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

import 'estate_profile_without_comment/estate_profile_screen.dart';

class EstatesMapScreen extends StatefulWidget {
  EstatesMapScreen({super.key});

  @override
  State<EstatesMapScreen> createState() => _EstatesMapScreenState();
}

class _EstatesMapScreenState extends State<EstatesMapScreen> with TickerProviderStateMixin {
  List<City> cities = [];

  bool _showFileOnMyLocation = false;
  bool _firstTime = false;

  @override
  initState() {
    super.initState();

    bloc.stream.listen(listener);

    getData();
  }

  getData() async {
    await getCities();
    getEstates();
  }

  List<CircleMarker> circles = [];

  getCities() async {
    var mCities = await City.getList(key: "estates");
    setState(() {
      cities = mCities;
    });

    if (cities.isEmpty) {
      await goSelectCity();
    }
  }

  getEstatesFirstTime() async {
    await getCities();
    if (await _getLocation()) {
      setState(() {
        _showFileOnMyLocation = true;
        _firstTime = true;
      });
    }

    getEstates();
  }

  getEstates({bool showMyLocation = false}) {
    bloc.add(
      EstateLoadEvent(
        city_ids: cities.map((e) => e.id!).toList(),
        search: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
        latLng: (_showFileOnMyLocation && myLocationMarker != null) ? myLocationMarker!.point : null,
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

  List<Estate> estates = [];

  List<Marker> markers = [];

  @override
  void dispose() {
    super.dispose();

    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title: TextField2(
            decoration: InputDecoration(
              hintText: "جستجو در دفاتر املاک",
              hintStyle: TextStyle(color: App.theme.tooltipTheme.textStyle?.color, fontSize: 13),
              border: InputBorder.none,
            ),
            controller: _searchController,
            style: TextStyle(color: App.theme.textTheme.bodyLarge?.color, fontSize: 13),
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
                await goSelectCity();

                getEstates();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 17,
                ),
                child: Text(
                  getTitle(cities),
                  style: TextStyle(
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
            ),
          ),
        ),
        body: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FlutterMap(
                mapController: _controller,
                options: MapOptions(
                  center: defaultLocation,
                  interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                  zoom: 14.0,
                  minZoom: 9,
                  plugins: [
                    MarkerClusterPlugin(),
                  ],
                ),
                children: [
                  TileLayerWidget(
                    options: TileLayerOptions(
                      urlTemplate: App.isDark ? MAPBOX_TILE_DARK : MAPBOX_TILE_LIGHT,
                    ),
                  ),
                  CircleLayerWidget(
                    options: CircleLayerOptions(
                      circles: circles,
                    ),
                  ),
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      spiderfyCircleRadius: 80,
                      spiderfySpiralDistanceMultiplier: 2,
                      circleSpiralSwitchover: 50,
                      maxClusterRadius: 120,
                      rotate: true,
                      size: const Size(40, 40),
                      anchor: AnchorPos.align(AnchorAlign.center),
                      fitBoundsOptions: const FitBoundsOptions(
                        padding: EdgeInsets.all(50),
                        maxZoom: 100,
                      ),
                      markers: markers,
                      polygonOptions: const PolygonOptions(borderColor: Colors.blueAccent, color: Colors.black12, borderStrokeWidth: 3),
                      builder: (context, markers) {
                        return Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.blue),
                          child: Center(
                            child: Text(
                              markers.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: App.theme.dialogBackgroundColor,
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
                      circles.removeAt(1);
                      myLocationMarker = null;
                    });

                    getEstates();
                    return;
                  }

                  getEstatesFirstTime();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _showFileOnMyLocation ? App.theme.primaryColor : App.theme.dialogBackgroundColor,
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
                    "فقط اطراف من",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "IranSansMedium",
                      color: _showFileOnMyLocation ? App.theme.canvasColor : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  goSelectCity() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectCityScreen(
          showSelected: false,
          saveCity: false,
          selectedCities: cities,
          alert: false,
        ),
      ),
    );

    if (result is List<City>) {
      setState(() {
        cities = result;
      });

      City.saveList(cities, key: "estates");

      await getCities();
      return;
    }

    Navigator.pop(context);
  }

  BuildContext? errorDialogContext;

  void listener(EstateState state) async {
    if (state is EstateLoadingState) {
      loadingDialog(context: context, showMessage: false);
    } else if (state is EstateErrorState) {
      dismissDialog(loadingDialogContext);

      showDialog2(
          context: context,
          barrierDismissible: false,
          builder: (
            _c,
          ) {
            errorDialogContext = _c;
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: Container(
                decoration: BoxDecoration(
                  color: App.theme.dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 170,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'خطا',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TryAgain(
                      onPressed: () {
                        dismissDialog(errorDialogContext);
                        if (_firstTime) {
                          getEstatesFirstTime();
                        } else {
                          getEstates();
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          });
    } else if (state is EstateLoadedState) {
      dismissDialog(loadingDialogContext);
      setState(() {
        estates = state.estates;
        markers = _buildEstateMarkers(estates);
      });
      if (_firstTime) {
        setState(() {
          _firstTime = false;
        });
        _onMyLocationClicked();
      } else {
        move(state);
      }

      if (estates.isEmpty) {
        notify("موردی یافت نشد");
      }
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

  Future<bool> hasLocationPermissions() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      return false;
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      return false;
    }

    return true;
  }

  Future<bool> _getLocation() async {
    if (!await getLocationPermissions()) {
      return false;
    }

    LocationData locationData = await _location.getLocation();

    if (locationData.latitude == null || locationData.longitude == null || locationData.latitude == 0 || locationData.longitude == 0) {
      return false;
    }

    var position = LatLng(locationData.latitude!, locationData.longitude!);

    setState(() {
      myLocationMarker = Marker(
        point: position,
        builder: _buildMapMarker,
      );
    });

    return true;
  }

  Future<void> _onMyLocationClicked() async {
    if (!await getLocationPermissions()) {
      notify("دسترسی موقعیت مکانی رد شده است لطفا به برنامه دسترسی بدهید");
      return;
    }

    notify("درحال دریافت موقعیت مکانی ...");

    LocationData locationData = await _location.getLocation();

    if (locationData.latitude == null || locationData.longitude == null || locationData.latitude == 0 || locationData.longitude == 0) {
      notify("موقعیت مکانی دریافت نشد");
      return;
    }

    var position = LatLng(locationData.latitude!, locationData.longitude!);

    setState(() {
      myLocationMarker = Marker(
        point: position,
        builder: _buildMapMarker,
      );
      circles = [
        CircleMarker(
          point: position,
          radius: 8,
          color: Colors.blue,
          borderStrokeWidth: 3,
          borderColor: Colors.white,
        ),
      ];
      animatedMapMove(_controller, position, getMapZoomLevel(1000), this);
    });

    if (_showFileOnMyLocation) {
      setState(() {
        circles.add(CircleMarker(
          point: position,
          radius: 1000,
          useRadiusInMeter: true,
          color: Colors.blue.withOpacity(0.15),
          borderStrokeWidth: 0,
        ));
      });
    }
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: App.theme.backgroundColor,
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
                                  color: App.theme.textTheme.bodyLarge?.color,
                                  fontSize: 14,
                                ),
                              ),
                              StaticStar(rating: estate.rate ?? 0.0),
                            ],
                          ),
                          SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "مدیریت : " + estate.managerName!,
                                style: TextStyle(
                                  color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "امتیار ${((estate.rate ?? 0.0) * 10).round() / 10} از 5",
                                style: TextStyle(
                                  color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
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
                                "موبایل : ${estate.phoneNumber}",
                                style: TextStyle(
                                  color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "تلفن : ${estate.telephoneNumber ?? "نامشخص"}",
                                style: TextStyle(
                                  color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 7),
                          Text(
                            "آدرس : ${estate.address}",
                            style: TextStyle(
                              color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
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
                                Navigator.push(context, MaterialPageRoute(builder: (_) => RequestFileScreen(estates: [estate])));
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              color: App.theme.primaryColor,
                              elevation: 1,
                              height: 50,
                              child: Text(
                                "ثبت درخواست",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5,
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
                                Navigator.push(context, MaterialPageRoute(builder: (_) => CreateFileFirst(estates: [estate])));
                              },
                              color: App.theme.primaryColor,
                              elevation: 1,
                              height: 50,
                              child: Text(
                                "ثبت فایل",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
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
                                  EstateProfileScreen(estateId: estate.id!, estateName: estate.name),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              color: App.theme.primaryColor,
                              elevation: 1,
                              height: 50,
                              child: Text(
                                "پروفایل",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
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
                          height: 70,
                          width: 122,
                          decoration: BoxDecoration(
                            color: App.isDark ? Color.fromARGB(255, 201, 201, 201) : Color(0xff707070),
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
                                  color: App.theme.canvasColor,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                "مدیریت : ${e.managerName}",
                                style: TextStyle(
                                  color: App.theme.canvasColor,
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
                                rating: e.rate ?? .0,
                                // initialRating: e.rate ?? 0.0,
                                // allowHalfRating: true,
                                // onRatingUpdate: (v) {},
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

  void move(EstateLoadedState state) {
    if (state.search && estates.isNotEmpty) {
      animatedMapMove(_controller, toLatLng(estates[0].lat!, estates[0].long!), _controller.zoom, this);
      return;
    }

    if (estates.isNotEmpty) {
      List<MapEntry<City, int>> data = [];

      cities.forEach((element) {
        data.add(MapEntry(element, estates.where((e) => e.cityId == element.id).length));
      });

      data.sort((a, b) => a.value.compareTo(b.value));

      var city = data.last.key;

      animatedMapMove(_controller, toLatLng(city.lat, city.long), 13.5, this);

      return;
    }
    
    animatedMapMove(_controller, toLatLng(cities[0].lat, cities[0].long), 13.5, this);
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
