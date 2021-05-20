import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mtbmap/screens/map/main.dart';
import 'package:mtbmap/screens/map/supporting/map_actions.dart';
import 'package:mtbmap/screens/panel/main.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'map/supporting/search-box.dart';
import 'map/supporting/search-results.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final double _initFabHeight = 120.0;
  late double _fabHeight;
  late double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
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
              topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
          onPanelSlide: (double pos) => setState(() {
            _fabHeight =
                pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
          }),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              MapView(mapController: _mapController),
              SafeArea(
                child: Column(
                  children: <Widget>[
                    SearchBox(),
                    SearchResults(mapController: _mapController),
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
        Positioned(
          right: 20.0,
          bottom: _fabHeight,
          child: MapActions(),
        ),
      ],
    ));
  }
}
