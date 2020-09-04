import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mtbmap/providers/location-provider/main.dart';
import 'package:provider/provider.dart';

class MapActions extends StatefulWidget {
  const MapActions({Key key}) : super(key: key);

  @override
  _MapActionsState createState() => _MapActionsState();
}

class _MapActionsState extends State<MapActions> {
  Modes activeMode = Modes.nothing;

  IconData _getIcon() {
    switch (activeMode) {
      case Modes.nothing:
        return Feather.map_pin;
      case Modes.getPosition:
        return Feather.navigation_2;
      case Modes.lock:
        return Feather.map;
    }
  }

  _action(LocationProvider locationProvider) async {
    switch (activeMode) {
      case Modes.nothing:
        setState(() {
          activeMode = Modes.getPosition;
        });
        var deviceLocation = await locationProvider.getDeviceLocation();
        locationProvider.setLocation(
            {"lat": deviceLocation.latitude, "lon": deviceLocation.longitude});
        break;
      case Modes.getPosition:
        setState(() {
          activeMode = Modes.lock;
        });
        locationProvider.toggleTracking(true);
        break;
      case Modes.lock:
        setState(() {
          activeMode = Modes.nothing;
        });
        locationProvider.toggleTracking(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    return FloatingActionButton(
      child: Icon(
        _getIcon(),
        color: Theme.of(context).primaryColor,
      ),
      onPressed: () => _action(locationProvider),
      backgroundColor: Colors.white,
    );
  }
}

enum Modes { nothing, getPosition, lock }
