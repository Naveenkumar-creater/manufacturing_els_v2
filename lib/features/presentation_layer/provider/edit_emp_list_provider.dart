import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/edit_emp_list_entity.dart';

class EditEmpListProvider extends ChangeNotifier {
  EditListofEmpWorkstationEntity? _user;

 EditListofEmpWorkstationEntity ? get user=> _user ;

 void setUser (EditListofEmpWorkstationEntity user){
  _user= user;
  notifyListeners();

 }


}