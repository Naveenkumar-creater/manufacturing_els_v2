import 'package:prominous/features/domain/entity/edit_incident_entity.dart';

class EditIncidentListModel extends EditIncidentListEntity {
    EditIncidentListModel({
        required this.editIncidentList,
    }):super(editIncidentList:editIncidentList );

    final List<EditIncidentList> editIncidentList;

    factory EditIncidentListModel.fromJson(Map<String, dynamic> json){ 
        return EditIncidentListModel(
            editIncidentList: json["response_data"]["Edit_Incident_List"] == null ? [] : List<EditIncidentList>.from(json["response_data"]["Edit_Incident_List"]!.map((x) => EditIncidentList.fromJson(x))),
        );
    }

    

}

class EditIncidentList extends EditIncidentEntity{
    EditIncidentList({
        required this.subincidentName,
        required this.incmName,
        required this.ipdincId,
        required this.ipdincIpdId,
        required this.ipdincIncmId,
        required this.ipdincNotes,
        required this.ipdincIncrcmId,
    }):super(incmName: incmName,ipdincId:ipdincId ,ipdincIncmId: ipdincIncmId,ipdincIncrcmId:ipdincIncrcmId ,ipdincIpdId:ipdincIpdId ,ipdincNotes:ipdincNotes ,subincidentName:subincidentName,);

    final String? subincidentName;
    final String? incmName;
    final int? ipdincId;
    final int? ipdincIpdId;
    final int? ipdincIncmId;
    final String? ipdincNotes;
    final int? ipdincIncrcmId;

    factory EditIncidentList.fromJson(Map<String, dynamic> json){ 
        return EditIncidentList(
            subincidentName: json["subincident_name"],
            incmName: json["incm_name"],
            ipdincId: json["ipdinc_id"],
            ipdincIpdId: json["ipdinc_ipd_id"],
            ipdincIncmId: json["ipdinc_incm_id"],
            ipdincNotes: json["ipdinc_notes"],
            ipdincIncrcmId: json["ipdinc_incrcm_id"],
        );
    }

 

}
