import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/emp_details_entity.dart';
import 'package:prominous/features/domain/entity/process_entity.dart';

class EmpDetailsProvider extends ChangeNotifier {
  EmpDetailsEntity? _user;
  EmpDetailsEntity? get user => _user;
  void setUser(EmpDetailsEntity process) {
    _user = process;
    notifyListeners();
  }
}
