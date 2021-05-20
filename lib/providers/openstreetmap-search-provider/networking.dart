import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/models/details.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/models/reverse-result.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/models/search-result.dart';

class Networking {
  Dio _dio = Dio();

  /*Networking() {
    _dio = Dio();
    _dio.interceptors.add(DioCacheManager(
            CacheConfig(baseUrl: "https://nominatim.openstreetmap.org"))
        .interceptor);
  }*/

  Future<List<SearchResult>> fetch(String query) async {
    final response = await _dio.get(
      "https://nominatim.openstreetmap.org/search/?q=$query&format=json&addressdetails=1&countrycodes=no",
      /*options: buildCacheOptions(Duration(days: 7))*/
    );
    return searchResultFromJson(response.data);
  }

  Future<dynamic> fetchDetails(int placeId) async {
    try {
      final response = await _dio.get(
        "https://nominatim.openstreetmap.org/details?&place_id=$placeId&format=json",
        /*options: buildCacheOptions(Duration(days: 7))*/
      );
      return detailsFromJson(response.data);
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<ReverseResult?> reverseFetch(double lat, double lon) async {
    try {
      Response response = await _dio.get(
          "https://nominatim.openstreetmap.org/reverse?format=geojson&lat=$lat&lon=$lon");
      if (response.data is Map<String, dynamic>) {
        print("is map");
        return reverseResultFromJson(response.data);
      }
      throw Exception();
    } catch (err) {
      return null;
    }
  }
}
