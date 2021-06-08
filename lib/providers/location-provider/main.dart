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
  Location _location = Location();

  void init() async {
    PermissionStatus status = await _getLocationPermission();
    if (status == PermissionStatus.granted) {
      LocationData? deviceLocation = await getDeviceLocation();
      if (deviceLocation?.latitude != null &&
          deviceLocation?.longitude != null) {
        setLocation({
          "lat": deviceLocation!.latitude!,
          "lon": deviceLocation.longitude!
        });
      }
      Stream<LocationData>? stream = await getDeviceLocationStream();
      if (stream != null) {
        stream.listen((LocationData event) {
          print("got location event");
          if (trackingLatest) {
            double speed = event.speed ?? 0;
            double altitude = event.altitude ?? 0;
            _setSpeed((speed * 3.6).round());
            _setAltitude(altitude.round());
            setLocation(
                {"lat": event.latitude ?? 0, "lon": event.longitude ?? 0});
          }
        });
      } else {
        stream?.drain();
      }
    }
  }

  // ignore: close_sinks
  final _deviceLocation = BehaviorSubject<Map<String, double>>();
  Stream<Map<String, double>> get deviceLocation => _deviceLocation.stream;
  Function(Map<String, double>) get setLocation => (Map<String, double> val) {
        print("new location: $val");
        final value = {"lat": val["lat"]!, "lon": val["lon"]!};
        _deviceLocation.sink.add(value);
        if (trackingLatest && openStreetmapProvider != null)
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

  // ignore: close_sinks
  BehaviorSubject<bool> _tracking = BehaviorSubject<bool>.seeded(true);
  bool _trackingLatest = true;
  bool get trackingLatest => _trackingLatest;
  Stream<bool> get tracking => _tracking.stream;
  set setTracking(val) {
    _tracking.sink.add(val);
    _trackingLatest = val;
  }

  Function(bool) get toggleTracking => (bool val) async {
        setTracking = val;
        if (val) {
          final location = await deviceLocation.first;
          openStreetmapProvider?.setCenter = location;
        }
        notifyListeners();
      };

  Future<PermissionStatus> _getLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return Future.error('Location services are disabled.');
        ;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (_permissionGranted == PermissionStatus.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return _permissionGranted;
  }

  Function() get getDeviceLocation => () async {
        try {
          if (await _getLocationPermission() == PermissionStatus.granted) {
            return await _location.getLocation();
          }
        } catch (err) {
          return null;
        }
      };

  Future<Stream<LocationData>?> getDeviceLocationStream() async {
    try {
      if (await _getLocationPermission() == PermissionStatus.granted) {
        return _location.onLocationChanged;
      }
    } catch (err) {
      return null;
    }
  }
}
