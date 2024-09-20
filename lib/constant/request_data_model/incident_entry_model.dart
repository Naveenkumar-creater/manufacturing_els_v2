
class ListOfWorkStationIncident {
  ListOfWorkStationIncident({  this.ipdId,this.ipdIncId,this.fromtime, this.endtime,this.solutionName, this.problemsolvedName, this.solutionId, this.problemstatusId, this.productionStoppageId, this.problemName, this.problemCatagoryname, this.rootCausename, this.problemId, this.problemcatagoryId, this.rootCauseId, this.reasons}
      );

final String?fromtime;
final String?endtime;
final String?solutionName;
final String? problemsolvedName;
  final String? problemName;
  final String? problemCatagoryname;
  final String? rootCausename;
  final int? problemId;
  final int?problemcatagoryId;
  final int? rootCauseId;
  final int?solutionId;
final int?problemstatusId;
final int?productionStoppageId;

  final String ? reasons;
  final int? ipdId;
  final int? ipdIncId;

Map<String, dynamic> toJson() => {
"inc_from_time":fromtime,
 "inc_end_time":endtime,
  "solutionname":solutionName,
  "solution_id":solutionId,
"problem_solved_name":problemsolvedName,
"problem_solved_Id":problemstatusId,
"production_stoppage_id":productionStoppageId,
 "problemname":problemName,
"problemcatagoryname": problemCatagoryname,
"rootcausename": rootCausename,
"incident_id": problemId,
"subincident_id": problemcatagoryId,
"rootcause_id": rootCauseId,
"reason":reasons,
"ipdid":ipdId,
"ipdincid":ipdIncId
                                                      
      };
}


