import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:location/location.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/main.dart';
import 'package:rxdart/subjects.dart';

class LocationProvider with ChangeNotifier {
  LocationProvider() {
    init();
  }

  OpenStreetmapProvider? openStreetmapProvider;

  void init() async {
    LocationData deviceLocation = await getDeviceLocation();
    if (deviceLocation.latitude != null && deviceLocation.longitude != null) {
      setLocation(
          {"lat": deviceLocation.latitude!, "lon": deviceLocation.longitude!});
    }
    Stream<LocationData>? stream = await getDeviceLocationStream();
    if (stream != null) {
      stream.listen((LocationData event) {
        if (tracking) {
          double speed = event.speed ?? 0;
          double altitude = event.altitude ?? 0;
          _setSpeed((speed * 3.6).round());
          _setAltitude(altitude.round());
          setLocation({"lat": event.latitude!, "lon": event.longitude!});
        }
      });
    } else {
      stream?.drain();
    }
  }

  // ignore: close_sinks
  final _deviceLocation = BehaviorSubject<Map<String, double>>();
  Stream<Map<String, double>> get deviceLocation => _deviceLocation.stream;
  Function(Map<String, double>) get setLocation => (Map<String, double> val) {
        final value = {"lat": val["lat"]!, "lon": val["lon"]!};
        _deviceLocation.sink.add(value);
        if (tracking && openStreetmapProvider != null)
          openStreetmapProvider!.setCenter = value;
      };
  // ignore: close_sinks
  final _speed = BehaviorSubject<int>();
  Stream<int> get speed => _speed.stream;
  Function(int) get _setSpeed => (val) {
        if (val <= 0) val = 0;
        _speed.sink.add(val);
      };

  Function get direction => () {
        return FlutterCompass.events;
      };

  // ignore: close_sinks
  final _altitude = BehaviorSubject<int>();
  Stream<int> get altitude => _altitude.stream;
  Function(int) get _setAltitude => (val) {
        _altitude.sink.add(val);
      };

  bool _tracking = true;
  bool get tracking => _tracking;

  Function(bool) get toggleTracking => (bool val) async {
        _tracking = val;
        if (val) {
          final location = await deviceLocation.first;
          openStreetmapProvider?.setCenter = location;
        }
        notifyListeners();
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

  Future<Stream<LocationData>?> getDeviceLocationStream() async {
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
