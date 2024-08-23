import 'package:prominous/features/domain/entity/listof_problem_entity.dart';

class ListOfProblemModel extends ListOfProblemEntity {
    ListOfProblemModel({
        required this.listOfIncident,
    }):super(listOfIncident: listOfIncident);

    final List<ListOfIncident>? listOfIncident;

    factory ListOfProblemModel.fromJson(Map<String, dynamic> json){ 
        return ListOfProblemModel(
            listOfIncident: json["response_data"]["list_of_incident"] == null ? [] : List<ListOfIncident>.from(json["response_data"]["list_of_incident"]!.map((x) => ListOfIncident.fromJson(x))),
        );
    }

}

class ListOfIncident extends ListOfIncidentEntity {
    ListOfIncident({
        required this.incmMpmId,
        required this.incmName,
        required this.incmId,
        required this.incmDesc,
        required this.incmParentId,
    }):super(incmDesc: incmDesc,incmId: incmId,incmMpmId: incmMpmId,incmName: incmName,incmParentId: incmParentId);

    final int? incmMpmId;
    final String? incmName;
    final int? incmId;
    final String? incmDesc;
    final int? incmParentId;

    factory ListOfIncident.fromJson(Map<String, dynamic> json){ 
        return ListOfIncident(
            incmMpmId: json["incm_mpm_id"],
            incmName: json["incm_name"],
            incmId: json["incm_id"],
            incmDesc: json["incm_desc"],
            incmParentId: json["incm_parent_id"],
        );
    }


}