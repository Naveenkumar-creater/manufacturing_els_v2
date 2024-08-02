import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/activity_entity.dart';

class ActivityProvider extends ChangeNotifier{
  ActivityEntity? _user;
  ActivityEntity? get user =>_user;

  void setUser(ActivityEntity? activity){
    _user=activity;
    notifyListeners();
  }
}