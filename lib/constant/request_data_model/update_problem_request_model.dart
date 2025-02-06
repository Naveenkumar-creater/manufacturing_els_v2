class UpdateProblemModel {
    UpdateProblemModel({
        required this.clientAutToken,
        required this.apiFor,
        required this.ipdincId,
        required this.ipdincIpdId,
        required this.incFromTime,
        required this.incEndTime,
        required this.incidentId,
        required this.subincidentId,
        required this.rootcauseId,
        required this.solutionId,
        required this.problemSolvedStatus,
        required this.productionStopage,
        required this.notes,
        required this.orgid
    });

    final String? clientAutToken;
    final String? apiFor;
    final int? ipdincId;
    final int? ipdincIpdId;
    final String? incFromTime;
    final String? incEndTime;
    final int? incidentId;
    final int? subincidentId;
    final int? rootcauseId;
    final int? solutionId;
    final int? problemSolvedStatus;
    final int? productionStopage;
    final String? notes;
    final int? orgid;

    Map<String, dynamic> toJson() => {
        "client_aut_token": clientAutToken,
        "api_for": apiFor,
        "ipdinc_id": ipdincId,
        "ipdinc_ipd_id": ipdincIpdId,
        "inc_from_time": incFromTime,
        "inc_to_time": incEndTime,
        "incident_id": incidentId,
        "subincident_id": subincidentId,
        "rootcause_id": rootcauseId,
        "solution_id": solutionId,
        "problem_solved_status": problemSolvedStatus,
        "production_stopage": productionStopage,
        "notes": notes,
        "org_id":orgid
    };

}
