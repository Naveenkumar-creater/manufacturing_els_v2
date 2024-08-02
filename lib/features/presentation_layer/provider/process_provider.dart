import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/process_entity.dart';


class ProcessProvider extends ChangeNotifier {
  ProcessEntity? _user;
  ProcessEntity? get user => _user;
  void setUser(ProcessEntity process) {
    _user = process;
    notifyListeners();
  }
}
