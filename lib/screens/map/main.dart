import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mtbmap/providers/location-provider/main.dart';
import 'package:mtbmap/screens/map/supporting/map_marker.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  MapView({
    Key? key,
  }) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    locationProvider.selectedLocation.listen((Map<String, double> event) async {
      print("event $event");
      double lat = event["lat"]!;
      double lon = event["lon"]!;
      if (locationProvider.tracking()) {
        _mapController.move(LatLng(lat, lon), 14);
      } else {
        _mapController.move(LatLng(lat, lon), 13);
      }
    });
    return Container(
        child: StreamBuilder(
      stream: locationProvider.selectedLocation,
      builder: (context, AsyncSnapshot<Map<String, double>> snapshot) {
        double lat = snapshot.hasData ? snapshot.data!["lat"]! : 62.5942;
        double lon = snapshot.hasData ? snapshot.data!["lon"]! : 9.6912;
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            interactive: !locationProvider.tracking(),
            center: LatLng(lat, lon),
            zoom: 13.0,
            maxZoom: 16.0,
            minZoom: 5,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    "https://mtbmap.no/tiles/osm/mtbmap/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                tileFadeInDuration: 100),
            MarkerLayerOptions(
              markers: [
                Marker(
                    width: 50,
                    height: 50,
                    point: LatLng(lat, lon),
                    builder: (context) {
                      return MapMarker();
                    })
              ],
            ),
          ],
        );
      },
    ));
  }
}
