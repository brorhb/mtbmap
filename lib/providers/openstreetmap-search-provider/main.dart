import 'package:flutter/material.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/networking.dart';
import 'package:mtbmap/utils/debouncer.dart';
import 'package:rxdart/subjects.dart';
import "./models/search-result.dart";
import 'models/details.dart';

class OpenStreetmapProvider extends ChangeNotifier {
  List<SearchResult> searchResults = [];
  Networking _networking = Networking();

  Function(String) get search => (String input) {
        final debouncer = Debouncer(milliseconds: 300);
        debouncer.run(() async {
          searchResults = await _networking.fetch(input);
          notifyListeners();
        });
      };

  Function() get clearSearch => () {
        searchResults = [];
        notifyListeners();
      };

  // ignore: close_sinks
  final _centerMap = BehaviorSubject<Map<String, double>>();
  Stream<Map<String, double>> get centerMap => _centerMap.stream;
  set setCenter(Map<String, double> val) {
    _centerMap.sink.add(val);
  }

  // ignore: close_sinks
  final _centerSearch = BehaviorSubject<Map<String, double>>();
  Stream<Map<String, double>> get centerSearch => _centerSearch.stream;
  set setCenterSearch(Map<String, double> val) {
    _centerSearch.sink.add(val);
  }

  Future<Details?> getDetails(double lat, double lon) async {
    /*
    ReverseResult? reverseResult = await _networking.reverseFetch(lat, lon);
    if (reverseResult != null) {
      Details details;
      details = await _networking
          .fetchDetails(reverseResult.features.first.properties.placeId);
      return details;
    }
    */
    return null;
  }
}
