import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mtbmap/providers/location-provider/main.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/main.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/models/details.dart';
import 'package:mtbmap/screens/map/supporting/map_marker.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MapView extends StatefulWidget {
  final MapController mapController;
  MapView({Key? key, required this.mapController}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  BehaviorSubject<Details?> _tappedObjectStream = BehaviorSubject<Details?>();
  Stream<Details?> get tappedObjectStream => _tappedObjectStream.stream;
  Function(Details?) get setTappedObject => (val) {
        _tappedObjectStream.sink.add(val);
      };

  @override
  void dispose() {
    _tappedObjectStream.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    OpenStreetmapProvider openStreetmapProvider =
        Provider.of<OpenStreetmapProvider>(context);
    widget.mapController.mapEventStream.listen((MapEvent event) {
      if (event.source == MapEventSource.onDrag) {
        locationProvider.toggleTracking(false);
      }
    });

    FlutterCompass.events?.listen((event) async {
      if (locationProvider.trackingLatest) {
        widget.mapController.rotate(-(event.heading ?? 0 / 360));
      }
    });

    openStreetmapProvider.centerMap.listen((event) async {
      if (locationProvider.trackingLatest) {
        double lat = event["lat"]!;
        double lon = event["lon"]!;
        widget.mapController.move(LatLng(lat, lon), 14);
      }
    });
    return Container(
        child: StreamBuilder(
      stream: locationProvider.deviceLocation,
      builder: (context, AsyncSnapshot<Map<String, double>> snapshot) {
        double lat = snapshot.hasData ? snapshot.data!["lat"]! : 62.5942;
        double lon = snapshot.hasData ? snapshot.data!["lon"]! : 9.6912;
        return StreamBuilder(
            stream: tappedObjectStream,
            builder: (context, AsyncSnapshot<Details?> snapshot) {
              return FlutterMap(
                mapController: widget.mapController,
                options: MapOptions(
                  onTap: (LatLng val) async {
                    Details? details = await openStreetmapProvider.getDetails(
                        val.latitude, val.longitude);
                    if (details != null) {
                      Distance distance = Distance();
                      num difference = distance(
                        LatLng(val.latitude, val.longitude),
                        LatLng(
                          details.centroid.coordinates[1],
                          details.centroid.coordinates[0],
                        ),
                      );
                      if (difference < 500) {
                        setTappedObject(details);
                      } else {
                        setTappedObject(
                          Details(
                              placeId: 0,
                              parentPlaceId: 0,
                              osmType: "",
                              osmId: 0,
                              category: "",
                              type: "type",
                              adminLevel: 0,
                              localname: "Ingen info",
                              names: Names(name: ""),
                              addresstags: [],
                              countryCode: "",
                              indexedDate: DateTime.now(),
                              importance: 0,
                              calculatedImportance: 0,
                              extratags: Extratags(mtbName: "", mtbScale: ""),
                              rankAddress: 0,
                              rankSearch: 0,
                              isarea: false,
                              centroid: Centroid(
                                  coordinates: [val.longitude, val.latitude],
                                  type: ""),
                              geometry: Centroid(
                                  coordinates: [val.longitude, val.latitude],
                                  type: "")),
                        );
                      }
                    } else {
                      setTappedObject(null);
                    }
                  },
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
                          }),
                      if (snapshot.data != null)
                        Marker(
                            width: (10 * snapshot.data!.localname.length)
                                    .toDouble() +
                                16,
                            height: 50,
                            point: LatLng(
                                snapshot.data!.centroid.coordinates[1],
                                snapshot.data!.centroid.coordinates[0]),
                            builder: (context) {
                              return Card(
                                child: TextButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black)),
                                  child: Center(
                                    child: Text(snapshot.data!.localname),
                                  ),
                                  onPressed: () {
                                    setTappedObject(null);
                                  },
                                ),
                              );
                            })
                    ],
                  ),
                ],
              );
            });
      },
    ));
  }
}
