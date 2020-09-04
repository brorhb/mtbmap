import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:location/location.dart';
import 'package:rxdart/subjects.dart';

class LocationProvider with ChangeNotifier {
  LocationProvider() {
    init();
  }

  void init() async {
    LocationData deviceLocation = await getDeviceLocation();
    setLocation(
        {"lat": deviceLocation.latitude, "lon": deviceLocation.longitude});
  }

  final _selectedLocation = BehaviorSubject<Map<String, double>>();
  Stream<Map<String, double>> get selectedLocation => _selectedLocation.stream;
  Function(Map<String, double>) get setLocation => (val) {
        _selectedLocation.sink.add({"lat": val["lat"], "lon": val["lon"]});
      };

  final _speed = BehaviorSubject<int>();
  Stream<int> get speed => _speed.stream;
  Function(int) get _setSpeed => (val) {
        if (val <= 0) val = 0;
        _speed.sink.add(val);
      };

  Function get direction => () {
        return FlutterCompass.events;
      };

  final _altitude = BehaviorSubject<int>();
  Stream<int> get altitude => _altitude.stream;
  Function(int) get _setAltitude => (val) {
        _altitude.sink.add(val);
      };

  bool _tracking = false;
  Function() get tracking => () {
        return _tracking;
      };

  Function(bool) get toggleTracking => (bool val) async {
        _tracking = val;
        notifyListeners();
        Stream<LocationData> stream = await getDeviceLocationStream();
        if (val) {
          stream.listen((LocationData event) {
            if (tracking()) {
              _setSpeed((event.speed * 3.6).round());
              _setAltitude(event.altitude.round());
              setLocation({"lat": event.latitude, "lon": event.longitude});
            }
          });
        } else {
          stream.drain();
        }
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

  Future<Stream> getDeviceLocationStream() async {
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
    return location.onLocationChanged;
  }
}
