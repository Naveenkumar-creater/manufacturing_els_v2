import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/listof_problem_entity.dart';

class ListofproblemProvider extends ChangeNotifier{
  ListOfProblemEntity ? _user;

 ListOfProblemEntity? get user => _user;

 void setUser(ListOfProblemEntity user ){
   _user=user;
   notifyListeners();   
 }


}