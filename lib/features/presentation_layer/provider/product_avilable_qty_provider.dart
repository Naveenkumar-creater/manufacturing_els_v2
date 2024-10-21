import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/product_avilable_qty_entity.dart';


class ProductAvilableQtyProvider extends ChangeNotifier {
  ProductAvilableQtyEntity? _user;

 ProductAvilableQtyEntity ? get user=> _user ;

 void setUser (ProductAvilableQtyEntity user){
  _user=user;
  notifyListeners();

 }
   void reset() {
    _user = null;
    notifyListeners();
  }

}