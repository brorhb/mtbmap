import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPProvider extends ChangeNotifier {
  IAPProvider() {
    _init();
  }

  void _init() async {
    available = await _inAppPurchaseConnection.isAvailable();

    if (available) {
      await _getProducts();

      _subscription =
          _inAppPurchaseConnection.purchaseUpdatedStream.listen((data) {
        for (PurchaseDetails purchase in data) {
          if (purchase.pendingCompletePurchase) {
            _inAppPurchaseConnection.completePurchase(purchase);
          }
        }
        purchases.addAll(data);
      });
    }
  }

  InAppPurchaseConnection _inAppPurchaseConnection =
      InAppPurchaseConnection.instance;

  bool _available = true;
  bool get available => _available;
  set available(bool val) {
    _available = val;
    notifyListeners();
  }

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;
  set products(val) {
    _products = val;
    notifyListeners();
  }

  List<PurchaseDetails> _purchases = [];
  List<PurchaseDetails> get purchases => _purchases;
  set purchases(val) {
    _purchases = val;
    notifyListeners();
  }

  StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from(["tip_developer"]);
    ProductDetailsResponse response =
        await _inAppPurchaseConnection.queryProductDetails(ids);
    products = response.productDetails;
  }

  buyProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _inAppPurchaseConnection.buyConsumable(purchaseParam: purchaseParam);
  }
}
