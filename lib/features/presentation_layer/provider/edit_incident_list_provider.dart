import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/edit_incident_entity.dart';

class EditIncidentListProvider extends ChangeNotifier{
  EditIncidentListEntity? _user;

  EditIncidentListEntity? get user =>_user;

  void setUser(EditIncidentListEntity incident){ 
  _user= incident;
  notifyListeners();
  }



}