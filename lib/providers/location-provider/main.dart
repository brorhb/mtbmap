import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:rxdart/subjects.dart';

class LocationProvider with ChangeNotifier {

  LocationProvider() {
    init();
  }

  void init() async {
    LocationData deviceLocation = await getDeviceLocation();
    setLocation({
      "lat": deviceLocation.latitude,
      "lon": deviceLocation.longitude
    });
  }

  final _selectedLocation = BehaviorSubject<Map<String, double>>();
  Stream<Map<String, double>> get selectedLocation => _selectedLocation.stream;

  Function(Map<String, double>) get setLocation => (val) {
    print(val);
    _selectedLocation.sink.add({
      "lat": val["lat"],
      "lon": val["lon"]
    });
  };

  Function() get getDeviceLocation => () async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  };


}