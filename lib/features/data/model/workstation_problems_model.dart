import 'package:prominous/features/domain/entity/workstation_problem_entity.dart';

class WorkstationProblemsModel extends WorkstationProblemsEntity{
    WorkstationProblemsModel({
        required this.resolvedProblemInWs,
    });

    final List<ResolveProblemList> resolvedProblemInWs;

    factory WorkstationProblemsModel.fromJson(Map<String, dynamic> json){ 
        return WorkstationProblemsModel(
            resolvedProblemInWs: json["response_data"]["Resolved Problem in WS"] == null ? [] : List<ResolveProblemList>.from(json["response_data"]["Resolved Problem in WS"]!.map((x) => ResolveProblemList.fromJson(x))),
        );
    }

}

class ResolveProblemList extends ResolveProblemsEntity {
 ResolveProblemList 
({
   required this.subincidentName,
        required this.problemStatusId,
        required this.solId,
        required this.ipdPwsId,
        required this.endTime,
        required this.productionStopageId,
        required this.fromTime,
        required this.solDesc,
        required this.incidentId,
        required this.incmAssetType,
        required this.incrcmRootcauseBrief,
        required this.incmAssetId,
        required this.ipdincNotes,
        required this.subincidentId,
        required this.ipdincIncrcmId,
        required this.incidentName,
        required this.problemStatus,
        required this.ipdincid,
         required this.ipdincipdid
    }):super(endTime: endTime, fromTime: fromTime,incidentId: incidentId, incidentName:incidentName, incmAssetId: incmAssetId, incmAssetType: incmAssetType,ipdPwsId: ipdPwsId,incrcmRootcauseBrief: incrcmRootcauseBrief,
    
    ipdincIncrcmId: ipdincIncrcmId, ipdincNotes: ipdincNotes, problemStatus: problemStatus, problemStatusId: problemStatusId,productionStopageId: productionStopageId,solDesc: solDesc,solId: solId,subincidentId: subincidentId,subincidentName: subincidentName,ipdincid: ipdincid,ipdincipdid:ipdincipdid );

    final String? subincidentName;
    final int? problemStatusId;
    final int? solId;
    final int? ipdPwsId;
    final String? endTime;
    final int? productionStopageId;
    final String? fromTime;
    final String? solDesc;
    final int? incidentId;
    final int? incmAssetType;
    final String? incrcmRootcauseBrief;
    final int? incmAssetId;
    final String? ipdincNotes;
    final int? subincidentId;
    final int? ipdincIncrcmId;
    final String? incidentName;
    final String? problemStatus;
    final int? ipdincid;
    final int?ipdincipdid;


    factory ResolveProblemList.fromJson(Map<String, dynamic> json){ 
        return ResolveProblemList(
   subincidentName: json["subincident_name"],
            problemStatusId: json["problem_status_id"],
            solId: json["sol_id"],
            ipdPwsId: json["ipd_pws_id"],
            endTime: json["end_time"],
            productionStopageId: json["production_stopage_id"],
            fromTime: json["from_time"],
            solDesc: json["sol_desc"],
            incidentId: json["incident_id"],
            incmAssetType: json["incm_asset_type"],
            incrcmRootcauseBrief: json["incrcm_rootcause_brief"],
            incmAssetId: json["incm_asset_id"],
            ipdincNotes: json["ipdinc_notes"],
            subincidentId: json["subincident_id"],
            ipdincIncrcmId: json["ipdinc_incrcm_id"],
            incidentName: json["incident_name"],
            problemStatus: json["problem_status"],
            ipdincid:json["ipdinc_id"],
            ipdincipdid:json["ipdinc_ipd_id"]
            
        );
    }

}

