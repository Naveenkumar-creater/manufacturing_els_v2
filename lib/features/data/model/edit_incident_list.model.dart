import 'package:prominous/features/domain/entity/edit_incident_entity.dart';

class EditIncidentListModel extends EditIncidentListEntity {
  EditIncidentListModel({
    required this.editIncidentList,
  }) : super(editIncidentList: editIncidentList);

  final List<EditIncidentList> editIncidentList;

  factory EditIncidentListModel.fromJson(Map<String, dynamic> json) {
    return EditIncidentListModel(
      editIncidentList: json["response_data"]["Edit_Incident_List"] == null
          ? []
          : List<EditIncidentList>.from(json["response_data"]
                  ["Edit_Incident_List"]!
              .map((x) => EditIncidentList.fromJson(x))),
    );
  }
}

class EditIncidentList extends EditIncidentEntity {
  EditIncidentList(
      {required this.subincidentName,
      required this.problemStatusId,
      required this.incmName,
      required this.ipdincProblemEndTime,
      required this.ipdincId,
      required this.solId,
      required this.ipdincProductionStoppage,
      required this.ipdincIpdId,
      required this.ipdincIncmId,
      required this.ipdincNotes,
      required this.ipdincIncrcmId,
      required this.fromTime,
      required this.rootcauseDetails,
      required this.rootcauseName,
      required this.incidentId,
      required this.ipdincipdId,
      required this.subincidentId})
      : super(
          incidentId: incidentId,
          ipdincipdId: ipdincipdId,
          subincidentId: subincidentId,
          fromTime: fromTime,
          ipdincProblemEndTime: ipdincProblemEndTime,
          ipdincProductionStoppage: ipdincProductionStoppage,
          problemStatusId: problemStatusId,
          rootcauseDetails: rootcauseDetails,
          solId: solId,
          incmName: incmName,
          ipdincId: ipdincId,
          ipdincIncmId: ipdincIncmId,
          ipdincIncrcmId: ipdincIncrcmId,
          ipdincIpdId: ipdincIpdId,
          ipdincNotes: ipdincNotes,
          subincidentName: subincidentName,
          rootcauseName: rootcauseName,
        );

  final String? subincidentName;
  final int? problemStatusId;
  final String? incmName;
  final String? ipdincProblemEndTime;
  final int? ipdincId;
  final int? solId;
  final int? ipdincProductionStoppage;
  final int? ipdincIpdId;
  final int? ipdincIncmId;
  final String? ipdincNotes;
  final int? ipdincIncrcmId;
  final String? fromTime;
  final String? rootcauseDetails;
  final String? rootcauseName;
  final int? ipdincipdId;
  final int? incidentId;
  final int? subincidentId;

  factory EditIncidentList.fromJson(Map<String, dynamic> json) {
    return EditIncidentList(
        subincidentName: json["subincident_name"],
        problemStatusId: json["problem_status_id"],
        incmName: json["incm_name"],
        ipdincProblemEndTime: json["ipdinc_problem_end_time"],
        ipdincId: json["ipdinc_id"],
        solId: json["sol_id"],
        ipdincProductionStoppage: json["ipdinc_production_stoppage"],
        ipdincIpdId: json["ipdinc_ipd_id"],
        ipdincIncmId: json["ipdinc_incm_id"],
        ipdincNotes: json["ipdinc_notes"],
        ipdincIncrcmId: json["ipdinc_incrcm_id"],
        fromTime: json["from_time"],
        rootcauseDetails: json["incrcm_rootcause_details"],
        rootcauseName: json["incrcm_rootcause_brief"],
        ipdincipdId: json["ipdinc_ipd_id"],
        incidentId: json["incident_id"],
        subincidentId: json["subincident_id"]);
  }
}
