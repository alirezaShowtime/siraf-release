import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:siraf3/config.dart';
import 'package:url_launcher/url_launcher.dart';

class SimpleMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SimpleMap();

  double lat;
  double long;
  double width;
  double height;
  ImageProvider? markerImage;
  BorderRadius borderRadius;
  bool openGoogleMap;

  SimpleMap({
    required this.lat,
    required this.long,
    required this.width,
    this.borderRadius = BorderRadius.zero,
    this.markerImage,
    this.height = 150,
    this.openGoogleMap = true,
  });
}

class _SimpleMap extends State<SimpleMap> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: widget.height,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(widget.lat, widget.long),
            allowPanning: false,
            enableScrollWheel: false,
            adaptiveBoundaries: false,
            allowPanningOnScrollingParent: false,
            enableMultiFingerGestureRace: false,
            debugMultiFingerGestureWinner: false,
            slideOnBoundaries: false,
            interactiveFlags: InteractiveFlag.pinchZoom,
            zoom: 15.0,
            maxZoom: 18.0,
            minZoom: 12.0,
            onTap: (_, _1) {
              if (!widget.openGoogleMap) return;
              launchUrl(Uri.parse('geo:0,0?q=${widget.lat},${widget.long}'));
            },
          ),
          children: [
            TileLayerWidget(
              options: TileLayerOptions(urlTemplate: MAPBOX_TILE_LIGHT),
            ),
            MarkerLayerWidget(
              options: MarkerLayerOptions(
                markers: [
                  Marker(
                    point: LatLng(widget.lat, widget.long),
                    builder: (_) {
                      return Image(
                        image: widget.markerImage ?? AssetImage('assets/images/map_marker.png'),
                        width: 30,
                        height: 40,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
