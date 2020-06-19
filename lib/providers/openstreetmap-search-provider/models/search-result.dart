import 'dart:convert';

List<SearchResult> searchResultFromJson(dynamic data) => List<SearchResult>.from(data.map((x) => SearchResult.fromJson(x)));

String searchResultToJson(List<SearchResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchResult {
    SearchResult({
        this.placeId,
        this.licence,
        this.osmType,
        this.osmId,
        this.boundingbox,
        this.lat,
        this.lon,
        this.displayName,
        this.searchResultClass,
        this.type,
        this.importance,
        this.icon,
    });

    int placeId;
    String licence;
    OsmType osmType;
    int osmId;
    List<String> boundingbox;
    String lat;
    String lon;
    String displayName;
    String searchResultClass;
    String type;
    double importance;
    String icon;

    factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        placeId: json["place_id"],
        licence: json["licence"],
        osmType: osmTypeValues.map[json["osm_type"]],
        osmId: json["osm_id"],
        boundingbox: List<String>.from(json["boundingbox"].map((x) => x)),
        lat: json["lat"],
        lon: json["lon"],
        displayName: json["display_name"],
        searchResultClass: json["class"],
        type: json["type"],
        importance: json["importance"].toDouble(),
        icon: json["icon"] == null ? null : json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "licence": licence,
        "osm_type": osmTypeValues.reverse[osmType],
        "osm_id": osmId,
        "boundingbox": List<dynamic>.from(boundingbox.map((x) => x)),
        "lat": lat,
        "lon": lon,
        "display_name": displayName,
        "class": searchResultClass,
        "type": type,
        "importance": importance,
        "icon": icon == null ? null : icon,
    };
}

enum OsmType { RELATION, NODE, WAY }

final osmTypeValues = EnumValues({
    "node": OsmType.NODE,
    "relation": OsmType.RELATION,
    "way": OsmType.WAY
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}