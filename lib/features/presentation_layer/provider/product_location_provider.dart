import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/product_location_entity.dart';


class ProductLocationProvider extends ChangeNotifier {
  ProductLocationEntity? _user;

 ProductLocationEntity ? get user=> _user ;

 void setUser (ProductLocationEntity user){
  _user=user;
  notifyListeners();

 }
   void reset() {
    _user = null;
    notifyListeners();
  }

}