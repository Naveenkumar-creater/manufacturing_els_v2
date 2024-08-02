import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/shift_status_entity.dart';

class ShiftStatusProvider extends ChangeNotifier {
  ShiftStatusEntity? _user;
  ShiftStatusEntity? get user => _user;
  void setUser(ShiftStatusEntity actual) {
    _user = actual;
    notifyListeners();
  }
}
