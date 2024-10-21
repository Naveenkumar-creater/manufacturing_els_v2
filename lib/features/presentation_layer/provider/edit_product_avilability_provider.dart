
import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/edit_product_avilabilty_entity.dart';
import 'package:prominous/features/domain/entity/product_avilable_qty_entity.dart';


class EditProductAvilableQtyProvider extends ChangeNotifier {
  EditProductAvilabiltyEntity? _user;

 EditProductAvilabiltyEntity ? get user=> _user ;

 void setUser (EditProductAvilabiltyEntity user){
  _user=user;
  notifyListeners();

 }
   void reset() {
    _user = null;
    notifyListeners();
  }

}