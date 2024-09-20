import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/problem_status_entity.dart';

class ProblemStatusProvider extends ChangeNotifier {

  ProblemStatusEntity ? _user;

  ProblemStatusEntity? get user=>_user;

  void setUser(ProblemStatusEntity user){
    _user=user;
    notifyListeners();
  }

}