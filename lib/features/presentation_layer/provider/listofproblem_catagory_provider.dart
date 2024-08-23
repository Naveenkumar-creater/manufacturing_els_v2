import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/listof_problem_entity.dart';
import 'package:prominous/features/domain/entity/listofproblem_catagory_entity.dart';

class ListofproblemCatagoryProvider extends ChangeNotifier{
  ListOfProblemCatagoryEntity ? _user;

 ListOfProblemCatagoryEntity? get user => _user;

 void setUser(ListOfProblemCatagoryEntity user ){
   _user=user;
   notifyListeners();   

 }

 void reset(){
  _user=null;
  notifyListeners();
 }


}