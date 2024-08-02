import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/AllocationEntity.dart';

class AllocationProvider extends ChangeNotifier {
  AllocationEntity? _user;
  AllocationEntity? get User => _user;
  void setUser(AllocationEntity allocation) {
    _user = allocation;
    notifyListeners();
  }
}
