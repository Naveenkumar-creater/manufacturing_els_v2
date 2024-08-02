import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/listofworkstation_entity.dart';
import 'package:prominous/features/domain/entity/scannerforworkstation_entity.dart';

class ScanforworkstationProvider extends ChangeNotifier {
  ScannerforworkstationEntity? _user;

 ScannerforworkstationEntity ? get user=> _user ;

 void setUser (ScannerforworkstationEntity user){
  _user=user;
  notifyListeners();

 }
  void reset() {
    _user = null;
    notifyListeners();
  }

}