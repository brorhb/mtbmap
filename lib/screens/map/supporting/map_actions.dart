import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mtbmap/providers/location-provider/main.dart';
import 'package:provider/provider.dart';

class MapActions extends StatefulWidget {
  const MapActions({Key? key}) : super(key: key);

  @override
  _MapActionsState createState() => _MapActionsState();
}

class _MapActionsState extends State<MapActions> {
  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    return StreamBuilder(
        stream: locationProvider.tracking,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          bool tracking = snapshot.data ?? true;
          print("tracking: $tracking");
          if (snapshot.hasData) {
            if (Platform.isIOS) {
              return FloatingActionButton(
                child: Icon(
                  tracking ? FeatherIcons.compass : FeatherIcons.navigation,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => locationProvider.toggleTracking(!tracking),
                backgroundColor: Colors.white,
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: IconButton(
                        onPressed: () {
                          locationProvider.getDeviceLocation();
                          locationProvider.toggleTracking(!tracking);
                        },
                        icon: Icon(
                          tracking
                              ? FeatherIcons.compass
                              : FeatherIcons.navigation,
                          color: Theme.of(context).primaryColor,
                        )),
                  ),
                ),
              );
            }
          } else {
            return Container();
          }
        });
  }
}

enum Modes { getPosition, lock }
