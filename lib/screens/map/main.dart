import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:mtbmap/providers/location-provider/main.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/main.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/models/details.dart';
import 'package:provider/provider.dart';
import './supporting/search-box.dart';
import './supporting/search-results.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    OpenStreetmapProvider openStreetmapProvider =
        Provider.of<OpenStreetmapProvider>(context);
    locationProvider.selectedLocation.listen((event) {
      double lat = event["lat"];
      double lon = event["lon"];
      _mapController.move(LatLng(lat, lon), 13);
    });
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
              child: StreamBuilder(
            stream: locationProvider.selectedLocation,
            builder: (context, snapshot) {
              double lat = snapshot.hasData ? snapshot.data["lat"] : 62.5942;
              double lon = snapshot.hasData ? snapshot.data["lon"] : 9.6912;
              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(lat, lon),
                  zoom: 13.0,
                  maxZoom: 16.0,
                  minZoom: 5,
                  /*onTap: (LatLng latLon) async {
                      double lat = latLon.latitude;
                      double lon = latLon.longitude;
                      Details details =
                          await openStreetmapProvider.getDetails(lat, lon);
                      if (details.centroid != null) {
                        locationProvider.setLocation({
                          "lat": details.centroid.coordinates[1],
                          "lon": details.centroid.coordinates[0]
                        });
                      }
                      showBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  top: 5, left: 15, right: 15),
                              height: 160,
                              width: MediaQuery.of(context).size.width - 16,
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(details?.localname ?? "No trail name"),
                                    Text(details?.extratags?.mtbScale ??
                                        "Unknown grading")
                                  ]),
                            );
                          });
                    }*/
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
                          width: 25,
                          height: 25,
                          point: LatLng(lat, lon),
                          builder: (context) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.black, width: 2)),
                              child: Padding(
                                padding: EdgeInsets.all(3),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                ],
              );
            },
          )),
          SafeArea(
            child: Column(
              children: <Widget>[
                SearchBox(),
                SearchResults(),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Platform.isAndroid ? 8 : 0, horizontal: 8),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Padding(
                            child: Text("Data innhentet fra mtbmap.no"),
                            padding: EdgeInsets.only(left: 8)),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.pin_drop),
        onPressed: () async {
          LocationData deviceLocation =
              await locationProvider.getDeviceLocation();
          locationProvider.setLocation({
            "lat": deviceLocation.latitude,
            "lon": deviceLocation.longitude
          });
        },
      ),
    );
  }
}
