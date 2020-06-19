import 'package:dio/dio.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/models/search-result.dart';

class Networking {
  Dio _dio = Dio();

  Future<List<SearchResult>> fetch(String query) async {
    final response = await _dio.get(
      "https://nominatim.openstreetmap.org/search/?q=$query&format=json&addressdetails=1&countrycodes=no"
    );
    return searchResultFromJson(response.data);
  }
}