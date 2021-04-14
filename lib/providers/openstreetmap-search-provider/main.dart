import 'package:flutter/material.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/networking.dart';
import 'package:mtbmap/utils/debouncer.dart';
import "./models/search-result.dart";
import 'models/details.dart';
import 'models/reverse-result.dart';

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

  Future<Details> getDetails(double lat, double lon) async {
    ReverseResult reverseResult = await _networking.reverseFetch(lat, lon);
    Details details;
    details = await _networking
        .fetchDetails(reverseResult.features.first.properties.placeId);
    return details;
  }
}
