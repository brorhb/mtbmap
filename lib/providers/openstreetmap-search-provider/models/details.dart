// To parse this JSON data, do
//
//     final details = detailsFromJson(jsonString);

import 'dart:convert';

Details detailsFromJson(dynamic str) => Details.fromJson(str);

String detailsToJson(Details data) => json.encode(data.toJson());

class Details {
  Details({
    required this.placeId,
    required this.parentPlaceId,
    required this.osmType,
    required this.osmId,
    required this.category,
    required this.type,
    required this.adminLevel,
    required this.localname,
    required this.names,
    required this.addresstags,
    this.housenumber,
    this.calculatedPostcode,
    required this.countryCode,
    required this.indexedDate,
    required this.importance,
    required this.calculatedImportance,
    required this.extratags,
    this.calculatedWikipedia,
    required this.rankAddress,
    required this.rankSearch,
    required this.isarea,
    required this.centroid,
    required this.geometry,
  });

  int placeId;
  int parentPlaceId;
  String osmType;
  int osmId;
  String category;
  String type;
  int adminLevel;
  String localname;
  Names names;
  List<dynamic> addresstags;
  dynamic housenumber;
  dynamic calculatedPostcode;
  String countryCode;
  DateTime indexedDate;
  int importance;
  double calculatedImportance;
  Extratags extratags;
  dynamic calculatedWikipedia;
  int rankAddress;
  int rankSearch;
  bool isarea;
  Centroid centroid;
  Centroid geometry;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        placeId: json["place_id"],
        parentPlaceId: json["parent_place_id"],
        osmType: json["osm_type"],
        osmId: json["osm_id"],
        category: json["category"],
        type: json["type"],
        adminLevel: json["admin_level"],
        localname: json["localname"],
        names: Names.fromJson(json["names"]),
        addresstags: List<dynamic>.from(json["addresstags"].map((x) => x)),
        housenumber: json["housenumber"],
        calculatedPostcode: json["calculated_postcode"],
        countryCode: json["country_code"],
        indexedDate: DateTime.parse(json["indexed_date"]),
        importance: json["importance"],
        calculatedImportance: json["calculated_importance"].toDouble(),
        extratags: Extratags.fromJson(json["extratags"]),
        calculatedWikipedia: json["calculated_wikipedia"],
        rankAddress: json["rank_address"],
        rankSearch: json["rank_search"],
        isarea: json["isarea"],
        centroid: Centroid.fromJson(json["centroid"]),
        geometry: Centroid.fromJson(json["geometry"]),
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "parent_place_id": parentPlaceId,
        "osm_type": osmType,
        "osm_id": osmId,
        "category": category,
        "type": type,
        "admin_level": adminLevel,
        "localname": localname,
        "names": names.toJson(),
        "addresstags": List<dynamic>.from(addresstags.map((x) => x)),
        "housenumber": housenumber,
        "calculated_postcode": calculatedPostcode,
        "country_code": countryCode,
        "indexed_date": indexedDate.toIso8601String(),
        "importance": importance,
        "calculated_importance": calculatedImportance,
        "extratags": extratags.toJson(),
        "calculated_wikipedia": calculatedWikipedia,
        "rank_address": rankAddress,
        "rank_search": rankSearch,
        "isarea": isarea,
        "centroid": centroid.toJson(),
        "geometry": geometry.toJson(),
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class Centroid {
  Centroid({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory Centroid.fromJson(Map<String, dynamic> json) => Centroid(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class Extratags {
  Extratags({
    required this.mtbName,
    required this.mtbScale,
  });

  String mtbName;
  String mtbScale;

  factory Extratags.fromJson(Map<String, dynamic> json) => Extratags(
        mtbName: json["mtb:name"],
        mtbScale: json["mtb:scale"],
      );

  Map<String, dynamic> toJson() => {
        "mtb:name": mtbName,
        "mtb:scale": mtbScale,
      };
}

class Names {
  Names({
    required this.name,
  });

  String name;

  factory Names.fromJson(Map<String, dynamic> json) => Names(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
