import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mtbmap/providers/location-provider/main.dart';
import 'package:mtbmap/screens/map/main.dart';
import 'package:mtbmap/screens/map/supporting/compass.dart';
import 'package:mtbmap/screens/map/supporting/map_actions.dart';
import 'package:mtbmap/screens/panel/main.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'map/supporting/search-box.dart';
import 'map/supporting/search-results.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final double _initFabHeight = 120.0;
  late double _fabHeight;
  late double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _fabHeight = _initFabHeight;
    if (Platform.isAndroid)
      Future.delayed(Duration.zero, () {
        LocationProvider locationProvider =
            Provider.of<LocationProvider>(context, listen: false);
        locationProvider.init();
      });
    if (Platform.isIOS) WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (Platform.isIOS) {
      if (state == AppLifecycleState.resumed) {
        LocationProvider locationProvider =
            Provider.of<LocationProvider>(context);
        locationProvider.init();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            panelBuilder: (sc) => Panel(),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                MapView(mapController: _mapController),
                SafeArea(
                  child: Column(
                    children: <Widget>[
                      if (locationProvider.trackingLatest == false) SearchBox(),
                      if (locationProvider.trackingLatest == false)
                        SearchResults(mapController: _mapController),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                StreamBuilder(
                                    stream: _mapController.mapEventStream,
                                    builder: (context,
                                        AsyncSnapshot<MapEvent> snapshot) {
                                      return Compass(
                                        heading: _mapController.rotation,
                                        onTap: (int val) {
                                          locationProvider
                                              .toggleTracking(false);
                                          _mapController.rotate(0);
                                        },
                                      );
                                    }),
                                if (Platform.isAndroid) MapActions()
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      /*Row(
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
                      )*/
                    ],
                  ),
                )
              ],
            ),
          ),
          if (Platform.isIOS)
            Positioned(
              right: 20.0,
              bottom: _fabHeight,
              child: MapActions(),
            ),
        ],
      ),
    );
  }
}
