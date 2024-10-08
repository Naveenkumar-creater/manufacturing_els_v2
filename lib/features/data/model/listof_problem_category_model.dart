

import 'package:prominous/features/domain/entity/listofproblem_catagory_entity.dart';

class ListOfProbleCatagorymModel extends ListOfProblemCatagoryEntity {
    ListOfProbleCatagorymModel({
        required this.listOfIncidentcatagory,
    }):super(listOfIncidentcatagory: listOfIncidentcatagory);

    final List<ListOfIncidentCatagory>? listOfIncidentcatagory;

    factory ListOfProbleCatagorymModel.fromJson(Map<String, dynamic> json){ 
        return ListOfProbleCatagorymModel(
            listOfIncidentcatagory: json["response_data"]["list_of_incident_category"] == null ? [] : List<ListOfIncidentCatagory>.from(json["response_data"]["list_of_incident_category"]!.map((x) => ListOfIncidentCatagory.fromJson(x))),
        );
    }

}

class ListOfIncidentCatagory extends ListOfIncidentCatagoryEntity {
    ListOfIncidentCatagory({
     required this.incmassettype,required this.incmassetid,required this.incmparentid, 
        required this.incmMpmId,
        required this.incmName,
        required this.incmId,
        required this.incmDesc,
        required this.incmParentId,
    }):super(incmDesc: incmDesc,incmId: incmId,incmMpmId: incmMpmId,incmName: incmName,incmParentId: incmParentId,incmassetid: incmassetid,incmassettype: incmassettype,incmparentid:incmparentid);

    final int? incmMpmId;
    final String? incmName;
    final int? incmId;
    final String? incmDesc;
    final int? incmParentId;
    final int? incmassettype;
    final int? incmassetid;
    final int?incmparentid;


    factory ListOfIncidentCatagory.fromJson(Map<String, dynamic> json){ 
        return ListOfIncidentCatagory(
            incmMpmId: json["incm_mpm_id"],
            incmName: json["incm_name"],
            incmId: json["incm_id"],
            incmDesc: json["incm_desc"],
            incmParentId: json["incm_parent_id"],
            incmassettype: json["incm_asset_type"],
            incmassetid: json["incm_asset_id"],
            incmparentid: json ["incm_parent_id"]
        );
    }


}
