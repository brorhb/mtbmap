import 'package:flutter/material.dart';
import 'package:mtbmap/providers/location-provider/main.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/main.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/models/search-result.dart';
import 'package:provider/provider.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OpenStreetmapProvider openStreetmapProvider =
        Provider.of<OpenStreetmapProvider>(context);
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    if (openStreetmapProvider.searchResults.isEmpty) {
      return SizedBox(height: 0, width: 0);
    } else {
      return Padding(
          padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
          child: Column(
            children: <Widget>[
              SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width - 16,
                  child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black38,
                                blurRadius: 8.0,
                                offset: Offset(8, 4))
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: ListView.builder(
                          itemCount: openStreetmapProvider.searchResults.length,
                          itemBuilder: (context, index) {
                            SearchResult item =
                                openStreetmapProvider.searchResults[index];
                            return ListTile(
                              title: Text(item.displayName),
                              onTap: () {
                                double lat = double.parse(item.lat);
                                double lon = double.parse(item.lon);
                                locationProvider.toggleTracking(false);
                                locationProvider
                                    .setLocation({"lat": lat, "lon": lon});
                                openStreetmapProvider.clearSearch();
                              },
                            );
                          })))
            ],
          ));
    }
  }
}
