import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';

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
          elevation: 0,
          backgroundColor: Themes.primary,
          title: Text(
            "موقعیت فایل",
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          leading: IconButton(
            onPressed: _popAndSendResult,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
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
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            Center(
              child: GestureDetector(
                onTap: _popAndSendResult,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                  child: Text(
                    "تایید",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
              Positioned(
                bottom: 20,
                left: MediaQuery.of(context).size.width / 2 - 60,
                child: GestureDetector(
                  onTap: _onMyLocationClicked,
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
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Icon(
                          Icons.my_location,
                          size: 30,
                          color: Themes.icon,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            "مکان من",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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
