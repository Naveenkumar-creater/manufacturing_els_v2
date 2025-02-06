
class ListOfWorkStationIncident {
  ListOfWorkStationIncident({ 
    required this.orgid,
    this.assetId, this.ipdId,this.ipdIncId,this.fromtime, this.endtime,this.solutionName, this.problemsolvedName, this.solutionId, this.problemstatusId, this.productionStoppageId, this.problemName, this.problemCategoryname, this.rootCausename, this.problemId, this.problemCategoryId, this.rootCauseId, this.reasons}
      );

final String?fromtime;
final String?endtime;
final String?solutionName;
final String? problemsolvedName;
final String? problemName;
  final String? problemCategoryname;
  final String? rootCausename;
  final int? problemId;
  final int?problemCategoryId;
  final int? rootCauseId;
  final int?solutionId;
final int?problemstatusId;
final int?productionStoppageId;
  final String ? reasons;
  final int? ipdId;
  final int? ipdIncId;
  final int?assetId;
  final int ? orgid;

Map<String, dynamic> toJson() => {
"inc_from_time":fromtime,
 "inc_end_time":endtime,
  "solutionname":solutionName,
  "solution_id":solutionId,
"problem_solved_name":problemsolvedName,
"problem_solved_Id":problemstatusId,
"production_stoppage_id":productionStoppageId,
 "problemname":problemName,
"problemCategoryname": problemCategoryname,
"rootcausename": rootCausename,
"incident_id": problemId,
"subincident_id": problemCategoryId,
"rootcause_id": rootCauseId,
"reason":reasons,
"ipdid":ipdId,
"ipdincid":ipdIncId,
  "assetid":assetId,
  "org_id": orgid
                                                      
      };
}


