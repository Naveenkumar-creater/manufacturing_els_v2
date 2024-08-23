// class workstationIncidentreqModel {
//   workstationIncidentreqModel({
//     required this.listOfWorkStationIncident,
//   });

//   final List<ListOfWorkStationIncident> listOfWorkStationIncident;
//   Map<String, dynamic> toJson() => {
//         "List_Of_WorkStation_incident": listOfWorkStationIncident
//             .map((listOfWorkStationIncident) =>
//                 listOfWorkStationIncident?.toJson())
//             .toList(),
//       };
// }

class ListOfWorkStationIncident {
  ListOfWorkStationIncident({this.problemName, this.problemCatagoryname, this.rootCausename, this.problemId, this.problemcatagoryId, this.rootCauseId, this.reasons}
      );

  final String? problemName;
  final String? problemCatagoryname;
  final String? rootCausename;
  final int? problemId;
  final int?problemcatagoryId;
  final int? rootCauseId;
  final String ? reasons;

Map<String, dynamic> toJson() => {
 "problemname":problemName,
 "problemcatagoryname": problemCatagoryname,
"rootcausename": rootCausename,
"incident_id": problemId,
"subincident_id": problemcatagoryId,
"rootcause_id": rootCauseId,
"reason":reasons
                                                      
      };
}


