import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/listofempworkstation_entity.dart';
import 'package:prominous/features/domain/entity/listofworkstation_entity.dart';

class ListofEmpworkstationProvider extends ChangeNotifier {
  ListofEmpWorkstationEntity? _user;

 ListofEmpWorkstationEntity ? get user=> _user ;

 void setUser (ListofEmpWorkstationEntity user){
  _user= user;
  notifyListeners();

 }


}