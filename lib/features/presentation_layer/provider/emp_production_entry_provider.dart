import 'package:flutter/foundation.dart';

import '../../domain/entity/emp_production_entity.dart';

class EmpProductionEntryProvider extends ChangeNotifier {
  EmpProductionEntity? _user;
  EmpProductionEntity? get user => _user;
  void setUser(EmpProductionEntity production) {
    _user = production;
    notifyListeners();
  }
}
