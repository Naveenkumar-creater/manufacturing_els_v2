import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/workstation_problem_entity.dart';

class WorkstationProblemProvider extends ChangeNotifier{
  WorkstationProblemsEntity ? _user;

WorkstationProblemsEntity ? get user=>_user;

void setUser(WorkstationProblemsEntity ? listofproblem){
  _user=listofproblem;
  notifyListeners();

}

}