import 'package:flutter/material.dart';
import 'package:mtbmap/providers/location-provider/main.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/main.dart';
import 'package:provider/provider.dart';
import "./screens/map/main.dart";

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MTBMap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<OpenStreetmapProvider>(
            create: (_) => OpenStreetmapProvider()
          ),
          ChangeNotifierProvider<LocationProvider>(
            create: (_) => LocationProvider(),
          )
        ],
        child: Map(),
      ),
    );
  }
}
