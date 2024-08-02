import 'package:flutter/material.dart';
import 'package:prominous/features/domain/entity/card_no_entity.dart';
import 'package:prominous/features/domain/entity/process_entity.dart';


class CardNoProvider extends ChangeNotifier {
  CardNoEntity? _user;
  CardNoEntity? get user => _user;
  void setUser(CardNoEntity cardNo) {
    _user = cardNo;
    notifyListeners();
  }
}
