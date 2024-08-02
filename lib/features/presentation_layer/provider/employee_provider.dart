import 'package:flutter/material.dart';
import '../../domain/entity/employee_entity.dart';

class EmployeeProvider extends ChangeNotifier {
  EmployeeEntity? _user;
  EmployeeEntity? get user => _user;

  // Method to update the employee ID
  void updateEmployeeId(int newEmployeeId) {
    if (_user != null && _user!.listofEmployeeEntity != null) {
      List<ListofEmployeeEntity> updatedList = [];
      for (var empEntity in _user!.listofEmployeeEntity!) {
        updatedList.add(empEntity.updateEmpPersonId(newEmployeeId));
      }
      _user = EmployeeEntity(listofEmployeeEntity: updatedList);
      notifyListeners();
    }
  }

  void setUser(EmployeeEntity employee) {
    _user = employee;
    notifyListeners();
  }

    void reset() {
    _user = null;
    notifyListeners();
  }
}
// class EmployeeProvider extends ChangeNotifier {
//   EmployeeEntity? _us/    EmployeeEntity? get user => _user;

//   // get listofEmployeeEntity => null;
//   void setUser(EmployeeEntity employee) {
//     _user = employee;
//     notifyListeners();
//   }
// }
