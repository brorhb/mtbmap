import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mtbmap/LocationProvider.dart';
import 'package:latlong2/latlong.dart';
import 'package:mtbmap/widgets/Compass.dart';
import 'package:mtbmap/widgets/MapMarker.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocationProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MtbMap Norge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MtbMap(),
    );
  }
}

class MtbMap extends StatefulWidget {
  MtbMap({Key? key}) : super(key: key);

  @override
  _MtbMapState createState() => _MtbMapState();
}

class _MtbMapState extends State<MtbMap> {
  final MapController mapController = MapController();
  bool tracking = true;
  var interactiveFlags = InteractiveFlag.rotate |
      InteractiveFlag.doubleTapZoom |
      InteractiveFlag.pinchZoom |
      InteractiveFlag.drag;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      LocationProvider locationProvider =
          Provider.of<LocationProvider>(context, listen: false);
      mapController.move(LatLng(62.6077, 9.6457), mapController.zoom);
      mapController.mapEventStream.listen((event) {
        if (event.source == MapEventSource.onDrag && tracking) {
          setState(() {
            tracking = false;
          });
        }
      });
      locationProvider.locationStream.listen((Position event) {
        if (tracking) {
          mapController.move(
              LatLng(event.latitude, event.longitude), mapController.zoom);
          mapController.rotate(-event.heading);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<Position>(
            stream: locationProvider.locationStream,
            builder: (context, snapshot) {
              Marker? marker;
              if (snapshot.hasData) {
                marker = Marker(
                  width: 50,
                  height: 50,
                  point:
                      LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                  builder: (context) {
                    return MapMarker();
                  },
                );
              }
              return FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  interactiveFlags: interactiveFlags,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        //'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        "https://mtbmap.no/tiles/osm/mtbmap/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                    tileProvider: NonCachingNetworkTileProvider(),
                  ),
                  MarkerLayerOptions(markers: [
                    if (marker != null) marker,
                  ])
                ],
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              double currentZoom = mapController.zoom;
                              double newZoom = currentZoom - 1;
                              mapController.move(mapController.center, newZoom);
                            },
                            child: Icon(Icons.zoom_out),
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          ElevatedButton(
                            onPressed: () {
                              double currentZoom = mapController.zoom;
                              double newZoom = currentZoom + 1;
                              mapController.move(mapController.center, newZoom);
                            },
                            child: Icon(Icons.zoom_in),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder(
                        stream: mapController.mapEventStream,
                        builder: (context, AsyncSnapshot<MapEvent> snapshot) {
                          return Compass(
                            heading: -mapController.rotation,
                            onTap: (int val) {
                              setState(() {
                                tracking = false;
                              });
                              mapController.rotate(0);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Spacer(),
                StreamBuilder<Position>(
                  stream: locationProvider.locationStream,
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SafeArea(
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Om MTBMap Norge",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Kartet er hentet fra mtbmap.no",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            "Denne appen lagde jeg fordi jeg ønsket meg en bedre oversikt over stiene i området mitt. Appen er egentlig lagd for å løse mine problemer, så om den løser dine også så blir jeg veldig glad!",
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.info),
                          ),
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Text(
                                  "${(snapshot.data?.speed ?? 0 * 3.6).ceil()} kmt",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 16),
                                ),
                                Text(
                                  "${(snapshot.data?.altitude ?? 0).ceil()} moh",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                tracking = !tracking;
                                if (tracking) {
                                  interactiveFlags = InteractiveFlag.rotate |
                                      InteractiveFlag.pinchZoom |
                                      InteractiveFlag.doubleTapZoom |
                                      InteractiveFlag.drag;
                                } else {
                                  interactiveFlags = InteractiveFlag.all;
                                }
                              });
                            },
                            child: tracking
                                ? Icon(Icons.navigation)
                                : Icon(Icons.navigation_outlined),
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
