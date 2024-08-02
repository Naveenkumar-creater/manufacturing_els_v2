import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/actual_qty_entity.dart';
import 'package:prominous/features/domain/entity/plan_qty_entity.dart';

class PlanQtyProvider extends ChangeNotifier {
  PlanQtyEntity? _user;
  PlanQtyEntity? get user => _user;
  void setUser(PlanQtyEntity actual) {
    _user = actual;
    notifyListeners();
  }
     void reset() {
    _user = null;
    notifyListeners();
  }
}
