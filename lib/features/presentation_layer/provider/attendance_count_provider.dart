import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/attendance_count_entity.dart';

class AttendanceCountProvider extends ChangeNotifier {
  AttendanceEntity? _user;
  AttendanceEntity? get user => _user;
  void setUser(AttendanceEntity attcount) {
    _user = attcount;
    notifyListeners();
  }
     void reset() {
    _user = null;
    notifyListeners();
  }
}
