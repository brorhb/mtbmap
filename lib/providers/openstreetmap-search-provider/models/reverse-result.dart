// To parse this JSON data, do
//
//     final reverseResult = reverseResultFromJson(jsonString);

import 'dart:convert';

ReverseResult reverseResultFromJson(Map<String, dynamic> str) =>
    ReverseResult.fromJson(str);

String reverseResultToJson(ReverseResult data) => json.encode(data.toJson());

class ReverseResult {
  ReverseResult({
    required this.type,
    required this.licence,
    required this.features,
  });

  String type;
  String licence;
  List<Feature> features;

  factory ReverseResult.fromJson(Map<String, dynamic> json) => ReverseResult(
        type: json["type"],
        licence: json["licence"],
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "licence": licence,
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
      };
}

class Feature {
  Feature({
    required this.type,
    required this.properties,
    required this.bbox,
    required this.geometry,
  });

  String type;
  Properties properties;
  List<double> bbox;
  Geometry geometry;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        type: json["type"],
        properties: Properties.fromJson(json["properties"]),
        bbox: List<double>.from(json["bbox"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "properties": properties.toJson(),
        "bbox": List<dynamic>.from(bbox.map((x) => x)),
        "geometry": geometry.toJson(),
      };
}

class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class Properties {
  Properties({
    required this.placeId,
    required this.osmType,
    required this.osmId,
    required this.placeRank,
    required this.category,
    required this.type,
    required this.importance,
    required this.addresstype,
    required this.name,
    required this.displayName,
    required this.address,
  });

  int placeId;
  String osmType;
  int osmId;
  int placeRank;
  String category;
  String type;
  double importance;
  String addresstype;
  String name;
  String displayName;
  Address address;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        placeId: json["place_id"],
        osmType: json["osm_type"],
        osmId: json["osm_id"],
        placeRank: json["place_rank"],
        category: json["category"],
        type: json["type"],
        importance: json["importance"].toDouble(),
        addresstype: json["addresstype"],
        name: json["name"],
        displayName: json["display_name"],
        address: Address.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "osm_type": osmType,
        "osm_id": osmId,
        "place_rank": placeRank,
        "category": category,
        "type": type,
        "importance": importance,
        "addresstype": addresstype,
        "name": name,
        "display_name": displayName,
        "address": address.toJson(),
      };
}

class Address {
  Address({
    required this.road,
    required this.hamlet,
    required this.town,
    required this.municipality,
    required this.county,
    required this.country,
    required this.countryCode,
  });

  String road;
  String hamlet;
  String town;
  String municipality;
  String county;
  String country;
  String countryCode;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        road: json["road"],
        hamlet: json["hamlet"],
        town: json["town"],
        municipality: json["municipality"],
        county: json["county"],
        country: json["country"],
        countryCode: json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "road": road,
        "hamlet": hamlet,
        "town": town,
        "municipality": municipality,
        "county": county,
        "country": country,
        "country_code": countryCode,
      };
}
