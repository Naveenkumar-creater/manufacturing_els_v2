import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/entity/target_qty_entity.dart';

class TargetQtyProvider extends ChangeNotifier{
  TargetQtyEntity? _user;
  TargetQtyEntity? get user =>_user;

  void setUser(TargetQtyEntity? Qty){
    _user=Qty;
    notifyListeners();
  }
}