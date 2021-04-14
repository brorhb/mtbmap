import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:mtbmap/providers/location-provider/main.dart';
import 'package:provider/provider.dart';

class Direction extends StatelessWidget {
  const Direction({Key? key}) : super(key: key);

  String _getDirection(int val) {
    if (val >= 0 && val < 22) {
      return "Nord";
    } else if (val >= 22 && val < 67) {
      return "Nord-øst";
    } else if (val >= 67 && val < 112) {
      return "Øst";
    } else if (val >= 112 && val < 157) {
      return "Sør-øst";
    } else if (val >= 157 && val < 202) {
      return "Sør";
    } else if (val >= 202 && val < 247) {
      return "Sør-vest";
    } else if (val >= 247 && val < 292) {
      return "Vest";
    } else if (val >= 292 && val < 337) {
      return "Nord-vest";
    } else {
      return "Nord";
    }
  }

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    return StreamBuilder(
      stream: locationProvider.direction(),
      builder: (context, AsyncSnapshot<CompassEvent> snapshot) {
        if (snapshot.hasData) {
          return Text(
            _getDirection(snapshot.data!.heading!.round()),
            style: TextStyle(fontWeight: FontWeight.bold),
          );
        } else {
          return Text(
            "Ikke tilgjenglig",
            style: TextStyle(color: Colors.grey),
          );
        }
      },
    );
  }
}
