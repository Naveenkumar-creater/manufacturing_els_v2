import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/rootcause_solution_entity.dart';

class RootcauseSolutionProvider extends ChangeNotifier{
  RootcauseSolutionEntity ? _user;

 RootcauseSolutionEntity? get user => _user;

 void setUser(RootcauseSolutionEntity user ){
   _user=user;
   notifyListeners();   
 }


}