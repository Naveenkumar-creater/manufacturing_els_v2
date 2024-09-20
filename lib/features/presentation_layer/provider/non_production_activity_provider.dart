import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/listofworkstation_entity.dart';
import 'package:prominous/features/domain/entity/non_production_activity_entity.dart';

class NonProductionActivityProvider extends ChangeNotifier {
  NonProductionActivityEntity? _user;

 NonProductionActivityEntity ? get user=> _user ;

 void setUser (NonProductionActivityEntity user){
  _user=user;
  notifyListeners();

 }
   void reset() {
    _user = null;
    notifyListeners();
  }

}