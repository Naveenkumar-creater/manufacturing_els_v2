import 'package:flutter/cupertino.dart';
import 'package:prominous/constant/request_data_model/incident_entry_model.dart';

class ListProblemStoringProvider extends ChangeNotifier {
  List<ListOfWorkStationIncident> _incidentList = [];

  List<ListOfWorkStationIncident> get getIncidentList => _incidentList;

  void addIncidentList(ListOfWorkStationIncident data) {
    _incidentList.add(data);
    print(_incidentList);
    notifyListeners();
  }

  void reset({bool notify = true}) {
    _incidentList = [];
    if (notify) {
      notifyListeners();
    }
  }
}
