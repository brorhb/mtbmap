import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  BehaviorSubject<Position> _locationStream = BehaviorSubject();
  Stream<Position> get locationStream => _locationStream.stream;
  set _setLocation(Position val) {
    _locationStream.sink.add(val);
  }

  LocationProvider() {
    init();
  }

  void init() async {
    bool permission = await getPermission();
    if (permission) {
      Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.bestForNavigation)
          .listen(
        (event) {
          _setLocation = event;
        },
      );
    }
  }

  Future<bool> getPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {}

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {}
    }

    if (permission == LocationPermission.deniedForever) {}
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  @override
  void dispose() {
    _locationStream.drain();
    super.dispose();
  }
}
