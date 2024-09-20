
import 'package:flutter/material.dart';
import 'package:prominous/constant/request_data_model/non_production_entry_model.dart';

class NonProductionStoredListProvider extends ChangeNotifier {
  List<NonProductionEntryModel> _nonProductionList = [];

  List<NonProductionEntryModel> get getNonProductionList => _nonProductionList;

  void addNonProductionList(NonProductionEntryModel data) {
    _nonProductionList.add(data);
    print(_nonProductionList);
    notifyListeners();
  }

  void reset({bool notify = true}) {
    _nonProductionList = [];
    if (notify) {
      notifyListeners();
    }
  }
}