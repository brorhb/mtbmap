import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mtbmap/providers/openstreetmap-search-provider/main.dart';
import 'package:provider/provider.dart';

class SearchBox extends StatefulWidget {
  SearchBox({Key? key}) : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  var _controller = TextEditingController();
  bool showDrawer = false;

  @override
  Widget build(BuildContext context) {
    OpenStreetmapProvider openStreetmapProvider =
        Provider.of<OpenStreetmapProvider>(context);

    double paddingTop = Platform.isAndroid ? 8 : 0;

    return Padding(
      padding: EdgeInsets.fromLTRB(8, paddingTop, 8, 0),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black38, blurRadius: 8.0, offset: Offset(8, 4))
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: TextField(
            controller: _controller,
            onChanged: (val) {
              openStreetmapProvider.search(val);
            },
            decoration: InputDecoration(
              hintText: "Søk",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 15, right: 15),
              suffixIcon: FocusScope.of(context).hasFocus
                  ? IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _controller.clear();
                        openStreetmapProvider.clearSearch();
                      },
                    )
                  : Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }
}
