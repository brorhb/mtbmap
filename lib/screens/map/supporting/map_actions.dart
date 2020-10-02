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
  Modes activeMode = Modes.getPosition;

  // ignore: missing_return
  IconData _getIcon() {
    switch (activeMode) {
      case Modes.getPosition:
        return Feather.unlock;
      case Modes.lock:
        return Feather.lock;
    }
  }

  _action(LocationProvider locationProvider) async {
    switch (activeMode) {
      case Modes.getPosition:
        setState(() {
          activeMode = Modes.lock;
        });
        locationProvider.toggleTracking(true);
        break;
      case Modes.lock:
        setState(() {
          activeMode = Modes.getPosition;
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

enum Modes { getPosition, lock }
