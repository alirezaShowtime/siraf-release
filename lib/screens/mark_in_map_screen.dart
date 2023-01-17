import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/themes2.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class MarkInMapScreen extends StatefulWidget {
  LatLng? position;

  MarkInMapScreen({this.position, Key? key}) : super(key: key);

  @override
  State<MarkInMapScreen> createState() => _MarkInMapScreenState();
}

class _MarkInMapScreenState extends State<MarkInMapScreen> {
  MapController _controller = MapController();

  LatLng defaultLocation = LatLng(34.08892074204623, 49.7009108491914);

  List<Marker> markers = [];
  List<CircleMarker> circles = [];

  @override
  void initState() {
    super.initState();

    _controller = MapController();

    setLocation();
  }

  setLocation() async {
    if (widget.position != null) {
      _setMarker(null, widget.position!);
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

  // void getSelectedCityCameraPosition() async {
  //   var city = await City.get();

  //   if (city.latitude == null || city.longitude == null) return;

  //   var camPos = LatLng(city.latitude!, city.longitude!);

  //   _controller.move(camPos, 13);
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _popAndSendResult();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "موقعیت فایل",
            style: TextStyle(
              color: Themes.text,
              fontSize: 15,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Themes.icon,
              size: 22,
            ),
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          actions: [
            if (markers.isNotEmpty)
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      markers.clear();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "پاک کردن",
                      style: TextStyle(
                        fontSize: 14,
                        color: Themes.text,
                        fontFamily: "IranSansBold",
                      ),
                    ),
                  ),
                ),
              ),
            Center(
              child: GestureDetector(
                onTap: _popAndSendResult,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    "تایید",
                    style: TextStyle(
                      fontSize: 14,
                      color: Themes.text,
                      fontFamily: "IranSansBold",
                    ),
                  ),
                ),
              ),
            ),
          ],
          backgroundColor: Themes.background,
          elevation: 0.7,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              FlutterMap(
                mapController: _controller,
                options: MapOptions(
                  center: defaultLocation,
                  zoom: 13.0,
                  onTap: _setMarker,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=${MAPBOX_ACCESS_TOKEN}",
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
              Align(
                // bottom: 20,
                // left: MediaQuery.of(context).size.width / 2 - 55,
                // left: 0,
                // right: 0,
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: _onMyLocationClicked,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 120, maxHeight: 50),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Icon(
                            Typicons.location_outline,
                            size: 30,
                            color: Themes2.secondary,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: Text(
                              "مکان من",
                              style: TextStyle(
                                color: Themes.text,
                                fontSize: 14,
                                fontFamily: "IranSansBold",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Location _location = Location();

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

  void _onMyLocationClicked() async {
    if (!await getLocationPermissions()) {
      notify("دسترسی موقعیت مکانی رد شده است لطفا به برنامه دسترسی بدهید");
      return;
    }

    notify("در حال دریافت موقعیت مکانی");

    LocationData locationData = await _location.getLocation();

    if (locationData.latitude == null ||
        locationData.longitude == null ||
        locationData.latitude == 0 ||
        locationData.longitude == 0) {
      notify("موقعیت مکانی دریافت نشد");
      return;
    }

    var position = LatLng(locationData.latitude!, locationData.longitude!);

    _setMarker(null, position);

    _controller.move(position, 16);
  }

  void _setMarker(_, LatLng latLng) {
    setState(() {
      markers = [Marker(point: latLng, builder: _buildMapMarker)];
    });
  }

  void _popAndSendResult() {
    var position = markers.isEmpty ? null : markers.first.point;
    Navigator.pop(context, position);
  }
}
