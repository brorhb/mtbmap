import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mtbmap/providers/location-provider/main.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

class MapActions extends StatefulWidget {
  const MapActions({Key? key}) : super(key: key);

  @override
  _MapActionsState createState() => _MapActionsState();
}

class _MapActionsState extends State<MapActions> {
  BehaviorSubject<Modes> _activeModeStream = BehaviorSubject<Modes>();
  Stream<Modes> get activeModeStream => _activeModeStream.stream;
  Function(Modes) get setActiveMode => (val) {
        _activeModeStream.sink.add(val);
      };

  @override
  void initState() {
    super.initState();
    setActiveMode(Modes.getPosition);
  }

  // ignore: missing_return
  IconData _getIcon(Modes activeMode) {
    switch (activeMode) {
      case Modes.getPosition:
        return FeatherIcons.navigation;
      case Modes.lock:
        return FeatherIcons.compass;
    }
  }

  _action(LocationProvider locationProvider, Modes activeMode) async {
    switch (activeMode) {
      case Modes.getPosition:
        setActiveMode(Modes.lock);
        locationProvider.toggleTracking(true);
        break;
      case Modes.lock:
        setActiveMode(Modes.getPosition);
        locationProvider.toggleTracking(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    return StreamBuilder(
        stream: locationProvider.deviceLocation,
        builder: (context, AsyncSnapshot<Map<String, double>> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton(
              child: Icon(
                locationProvider.tracking
                    ? FeatherIcons.compass
                    : FeatherIcons.navigation,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () =>
                  locationProvider.toggleTracking(!locationProvider.tracking),
              backgroundColor: Colors.white,
            );
          } else {
            return Container();
          }
        });
  }
}

enum Modes { getPosition, lock }
