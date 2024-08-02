import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/actual_qty_entity.dart';

class ActualQtyProvider extends ChangeNotifier {
  ActualQtyEntity? _user;
  ActualQtyEntity? get user => _user;
  void setUser(ActualQtyEntity actual) {
    _user = actual;
    notifyListeners();
  }

     void reset() {
    _user = null;
    notifyListeners();
  }
}
