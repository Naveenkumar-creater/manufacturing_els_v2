class workstationIncidentreqModel {
  workstationIncidentreqModel({
    required this.listOfWorkStationIncident,
  });

  final List<ListOfWorkStationIncident> listOfWorkStationIncident;
  Map<String, dynamic> toJson() => {
        "List_Of_WorkStation_incident": listOfWorkStationIncident
            .map((listOfWorkStationIncident) =>
                listOfWorkStationIncident?.toJson())
            .toList(),
      };
}

class ListOfWorkStationIncident {
  ListOfWorkStationIncident(
      {required this.incident,
      required this.subincident,
      required this.description});

  final String? incident;
  final String? subincident;
  final String? description;

  Map<String, dynamic> toJson() => {
        "incident": incident,
        "subincident": subincident,
        "description": description
      };
}
