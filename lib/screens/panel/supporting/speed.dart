import 'package:flutter/material.dart';
import 'package:mtbmap/providers/location-provider/main.dart';
import 'package:provider/provider.dart';

class Speed extends StatelessWidget {
  const Speed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    return StreamBuilder(
      stream: locationProvider.speed,
      builder: (context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          return Text(
            "${snapshot.data} kmt",
            style: TextStyle(fontWeight: FontWeight.bold),
          );
        } else {
          return Text(
            "0 kmt",
            style: TextStyle(color: Colors.grey),
          );
        }
      },
    );
  }
}
