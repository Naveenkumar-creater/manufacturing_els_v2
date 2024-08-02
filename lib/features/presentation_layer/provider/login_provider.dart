import 'package:flutter/material.dart';

import '../../domain/entity/login_entity.dart';

class LoginProvider extends ChangeNotifier {
  LoginEntity? _user;
  LoginEntity? get user => _user;
  void setUser(LoginEntity loginuser) {
    _user = loginuser;
    notifyListeners();
  }
}
