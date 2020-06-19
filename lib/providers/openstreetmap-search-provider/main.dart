import 'package:flutter/material.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/networking.dart';
import 'package:mtbmap/utils/debouncer.dart';
import "./models/search-result.dart";

class OpenStreetmapProvider extends ChangeNotifier {
  List<SearchResult> searchResults = [];
  Networking _networking = Networking();

  Function(String) get search => (String input) {
    final debouncer = Debouncer(milliseconds: 100);
    debouncer.run(() async {
      searchResults = await _networking.fetch(input);
      notifyListeners();
    });
  };

  Function() get clearSearch => () {
    searchResults = [];
    notifyListeners();
  };
}