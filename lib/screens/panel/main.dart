import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mtbmap/providers/in-app-purchase-provider.dart';
import 'package:mtbmap/screens/panel/supporting/altitude.dart';
import 'package:mtbmap/screens/panel/supporting/direction.dart';
import 'package:mtbmap/screens/panel/supporting/speed.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Panel extends StatelessWidget {
  const Panel({Key? key, this.sc}) : super(key: key);
  final ScrollController? sc;

  @override
  Widget build(BuildContext context) {
    IAPProvider iapProvider = Provider.of<IAPProvider>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: ListView(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Speed(),
                Altitude(),
                Direction(),
              ]),
          Container(padding: EdgeInsets.only(top: 40)),
          Text(
            "Om MTBMap Norge",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text("Kartet er hentet fra"),
          InkWell(
            child: Text("mtbmap.no",
                style: TextStyle(decoration: TextDecoration.underline)),
            onTap: () async {
              String _url = "http://mtbmap.no";
              if (await canLaunch(_url)) {
                await launch(_url);
              } else {
                throw 'Could not launch $_url';
              }
            },
          ),
          Text(
              "Tusen takk for at jeg fikk lov til å bruke det nydelige kartet deres! 😍"),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Text(
                "Denne appen lagde jeg fordi jeg ønsket meg en bedre oversikt over stiene i området mitt. Appen er egentlig lagd for å løse mine problemer, så om den løser dine også så blir jeg veldig glad!"),
          ),
          Text("Har du en ide, gjerne kontakt meg på"),
          InkWell(
            child: Text("bror@hey.com",
                style: TextStyle(decoration: TextDecoration.underline)),
            onTap: () async {
              String _url = "mailto:bror@hey.com";
              if (await canLaunch(_url)) {
                await launch(_url);
              } else {
                throw 'Could not launch $_url';
              }
            },
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
          ),
          if (Platform.isIOS && iapProvider.available) Tips()
        ],
      ),
    );
  }
}

class Tips extends StatelessWidget {
  const Tips({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IAPProvider iapProvider = Provider.of<IAPProvider>(context);
    List<ProductDetails> productDetails = iapProvider.products;
    if (productDetails.isNotEmpty)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Liker du appen godt? Og skulle du føle deg gavmild? Og har lyst til å spandere et par kaffekapsler på meg, så blir jeg ikke lei meg 🤷‍♂️"),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
              ),
              child: Text(
                "Tips ☕️",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (productDetails.length > 0) {
                  iapProvider.buyProduct(productDetails.first);
                }
              },
            ),
          )
        ],
      );
    else
      return Container();
  }
}
