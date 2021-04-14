import 'package:flutter/material.dart';
import 'package:mtbmap/providers/location-provider/main.dart';
import 'package:provider/provider.dart';

class Altitude extends StatelessWidget {
  const Altitude({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    return StreamBuilder(
      stream: locationProvider.altitude,
      builder: (context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData && locationProvider.tracking()) {
          return Text(
            "${snapshot.data} moh",
            style: TextStyle(fontWeight: FontWeight.bold),
          );
        } else {
          return Text(
            "0 moh",
            style: TextStyle(color: Colors.grey),
          );
        }
      },
    );
  }
}
