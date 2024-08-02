import 'package:flutter/material.dart';

import '../../domain/entity/recent_activity_entity.dart';


class RecentActivityProvider extends ChangeNotifier {
  RecentActivitiesEntity? _user;
  RecentActivitiesEntity? get user => _user;
  void setUser(RecentActivitiesEntity activity) {
    _user = activity;
    notifyListeners();
  }
}