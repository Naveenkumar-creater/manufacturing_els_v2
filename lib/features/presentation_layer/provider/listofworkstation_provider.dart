import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/listofworkstation_entity.dart';

class ListofworkstationProvider extends ChangeNotifier {
  ListOfWorkstationEntity? _user;

 ListOfWorkstationEntity ? get user=> _user ;

 void setUser (ListOfWorkstationEntity user){
  _user=user;
  notifyListeners();

 }
   void reset() {
    _user = null;
    notifyListeners();
  }

}