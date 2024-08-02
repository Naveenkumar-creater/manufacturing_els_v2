import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/product_entity.dart';


class ProductProvider extends ChangeNotifier {
  ProductEntity? _user;
  ProductEntity? get user => _user;
  void setUser(ProductEntity product) {
    _user = product;
    notifyListeners();
  }
}
