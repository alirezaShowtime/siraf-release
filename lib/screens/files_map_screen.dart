import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:siraf3/bloc/location_files_bloc.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/map_utilities.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/models/location_file.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/location_file_item.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';

import 'file_screen.dart';

class FilesMapScreen extends StatefulWidget {
  FilesMapScreen({super.key});

  @override
  State<FilesMapScreen> createState() => _FilesMapScreenState();
}

class _FilesMapScreenState extends State<FilesMapScreen> with TickerProviderStateMixin {
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
    getFiles();
  }

  List<CircleMarker> circles = [];

  getCities() async {
    var mCities = await City.getList(key: "files");
    setState(() {
      cities = mCities;
      filterData.cityIds = cities.map<int>((e) => e.id!).toList();
    });

    if (cities.isEmpty) {
      await goSelectCity();
    }
  }

  getFilesFirstTime() async {
    await getCities();
    if (await _getLocation()) {
      setState(() {
        _showFileOnMyLocation = true;
        _firstTime = true;
      });
    }

    getFiles();
  }

  getFiles({bool showMyLocation = false}) {
    bloc.add(
      LocationFilesEvent(
        search: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
        latLng: (_showFileOnMyLocation && myLocationMarker != null) ? myLocationMarker!.point : null,
        filterData: filterData,
      ),
    );
  }

  FilterData filterData = FilterData();

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

  LocationFilesBloc bloc = LocationFilesBloc();

  TextEditingController _searchController = TextEditingController();

  LatLng defaultLocation = LatLng(34.08892074204623, 49.7009108491914);

  List<LocationFile> files = [];

  List<Marker> markers = [];

  CarouselController carouselController = CarouselController();

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
          elevation: 0.7,
          title: TextField2(
            decoration: InputDecoration(
              hintText: "جستجو در فایل ها",
              hintStyle: TextStyle(color: App.theme.tooltipTheme.textStyle?.color, fontSize: 13),
              border: InputBorder.none,
            ),
            controller: _searchController,
            style: TextStyle(fontSize: 13, color: App.theme.textTheme.bodyLarge?.color),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              getFiles();
            },
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          actions: [
            GestureDetector(
              onTap: () async {
                await goSelectCity();
                getFiles();
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
                getFiles();
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
                    options: CircleLayerOptions(circles: circles),
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
              top: 10,
              right: 10,
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
              top: 10,
              right: 60,
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

                    getFiles();
                    return;
                  }

                  getFilesFirstTime();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _showFileOnMyLocation ? Themes.primary : App.theme.dialogBackgroundColor,
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
                      fontSize: 14,
                      fontFamily: "IranSansMedium",
                      color: _showFileOnMyLocation ? Themes.textLight : null,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: selectedFile != null,
              child: Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: CarouselSlider(
                  items: files
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FileScreen(id: e.id!),
                                  ),
                                );
                              },
                              child: LocationFileItem(
                                locationFile: e,
                              ),
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                      height: 120,
                      autoPlay: false,
                      viewportFraction: 0.9,
                      onPageChanged: (i, _) {
                        animatedMapMove(_controller, LatLng(double.parse(files.elementAt(i).lat!), double.parse(files.elementAt(i).long!)), _controller.zoom, this);
                      }),
                  carouselController: carouselController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LocationFile? selectedFile;

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

      City.saveList(cities, key: "files");

      await getCities();
    }
  }

  BuildContext? errorDialogContext;

  void listener(LocationFilesState state) {
    if (state is LocationFilesLoadingState) {
      dismissDialog(errorDialogContext);
      setState(() {
        selectedFile = null;
      });
      loadingDialog(context: context, showMessage: false);
    } else if (state is LocationFilesErrorState) {
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
                  color: Colors.white,
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TryAgain(
                      onPressed: () {
                        if (_firstTime) {
                          getFilesFirstTime();
                        } else {
                          getFiles();
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          });
    } else if (state is LocationFilesLoadedState) {
      dismissDialog(loadingDialogContext);
      setState(() {
        files = state.files;
        markers = _buildFileMarkers(files);

        print(markers.length);
      });
      if (_firstTime) {
        setState(() {
          _firstTime = false;
        });
        _onMyLocationClicked();
      } else {
        _controller.move(defaultLocation, 14);
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
      animatedMapMove(_controller, position, getMapZoomLevel(3000), this);
    });

    if (_showFileOnMyLocation) {
      setState(() {
        circles.add(CircleMarker(
          point: position,
          radius: 3000,
          useRadiusInMeter: true,
          color: Colors.blue.withOpacity(0.15),
          borderStrokeWidth: 0,
        ));
      });
    }
  }

  Widget _buildMapMarker(_) {
    return m.Image(
      image: AssetImage('assets/images/map_marker.png'),
      width: 30,
      height: 40,
      fit: BoxFit.contain,
    );
  }

  _buildFileMarkers(List<LocationFile> files) {
    return files.map<Marker>((e) {
      return Marker(
        width: 244,
        height: 120,
        point: LatLng(double.parse(e.lat!), double.parse(e.long!)),
        builder: (_) {
          // return Container(width: 5, height: 5, color: Themes.blue,);
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFile = e;
              });

              print(files.indexOf(e));

              carouselController.jumpToPage(files.indexOf(e));
            },
            child: Stack(
              children: [
                Positioned(
                  bottom: 60,
                  child: Container(
                    height: 60,
                    width: 122,
                    decoration: BoxDecoration(
                      color: Color(0xff707070),
                      border: Border.all(
                        color: Themes.icon,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: e.isRent() ? "ودیعه : " : "قیمت کل : ",
                                style: TextStyle(
                                  color: Themes.textLight,
                                  fontSize: 9,
                                  fontFamily: e.isRent() ? "IranSans" : "IranSansMedium",
                                ),
                              ),
                              TextSpan(
                                text: e.getFirstPrice(),
                                style: TextStyle(color: Themes.textLight, fontSize: e.isRent() ? 9 : 10, fontFamily: e.isRent() ? "IranSans" : "IranSansMedium"),
                              ),
                            ],
                          ),
                        ),
                        if (e.isRent())
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "اجاره : ",
                                  style: TextStyle(
                                    color: Themes.textLight,
                                    fontSize: 9,
                                    fontFamily: e.isRent() ? "IranSans" : "IranSansMedium",
                                  ),
                                ),
                                TextSpan(
                                  text: e.getSecondPrice(),
                                  style: TextStyle(color: Themes.textLight, fontSize: e.isRent() ? 9 : 10, fontFamily: e.isRent() ? "IranSans" : "IranSansMedium"),
                                ),
                              ],
                            ),
                          ),
                        Text(
                          e.name!,
                          style: TextStyle(
                            color: Themes.textLight,
                            fontSize: 9,
                          ),
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 57,
                  width: 244,
                  alignment: Alignment.bottomCenter,
                  child: m.Image(
                    image: AssetImage("assets/images/marker_pic.png"),
                    width: 27,
                    height: 40,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }).toList();
  }

  String getTitle(List<City> cities) {
    return cities.isEmpty
        ? "انتخاب شهر"
        : cities.length == 1
            ? cities.first.name ?? "${cities.length} شهر"
            : "${cities.length} شهر";
  }
}
