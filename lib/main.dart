import 'package:flutter/material.dart';
import 'package:mtbmap/providers/in-app-purchase-provider.dart';
import 'package:mtbmap/providers/location-provider/main.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/main.dart';
import 'package:mtbmap/screens/app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(EntryPoint());
}

class EntryPoint extends StatelessWidget {
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
              create: (_) => OpenStreetmapProvider()),
          ChangeNotifierProxyProvider<OpenStreetmapProvider, LocationProvider>(
            create: (_) => LocationProvider(),
            update: (_, openstreetmapProvider, locationProvider) {
              locationProvider!.openStreetmapProvider = openstreetmapProvider;
              return locationProvider;
            },
          ),
          ChangeNotifierProvider<IAPProvider>(
            create: (_) => IAPProvider(),
          )
        ],
        child: App(),
      ),
    );
  }
}
