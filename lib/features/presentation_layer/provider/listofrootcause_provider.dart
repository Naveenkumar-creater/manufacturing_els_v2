import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/listof_rootcause_entity.dart';

class ListofRootcauseProvider extends ChangeNotifier {

  ListOfRootCauseEntity ? _user;

  ListOfRootCauseEntity? get user=>_user;

  void setUser( ListOfRootCauseEntity user){
    _user=user;
    notifyListeners();
  }

  void reset() {
    _user = null;
    notifyListeners();
  

}

}