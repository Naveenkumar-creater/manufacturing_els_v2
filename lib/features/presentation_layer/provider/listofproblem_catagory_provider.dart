import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/listofproblem_catagory_entity.dart';

class ListofproblemCategoryProvider extends ChangeNotifier{
  ListOfProblemCategoryEntity ? _user;

 ListOfProblemCategoryEntity? get user => _user;

 void setUser(ListOfProblemCategoryEntity user ){
   _user=user;
   notifyListeners();   

 }

 void reset(){
  _user=null;
  notifyListeners();
 }


}