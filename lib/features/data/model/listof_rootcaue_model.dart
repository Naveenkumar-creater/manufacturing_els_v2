import 'package:prominous/features/domain/entity/listof_rootcause_entity.dart';

class ListOfRootCauseModel extends ListOfRootCauseEntity {
    ListOfRootCauseModel({
        required this.listOfRootcause,
    }):super(listrootcauseEntity: listOfRootcause);

    final List<ListOfRootcause>? listOfRootcause;

    factory ListOfRootCauseModel.fromJson(Map<String, dynamic> json){ 
        return ListOfRootCauseModel(
            listOfRootcause: json["response_data"]["list_of_rootcause"] == null ? [] : List<ListOfRootcause>.from(json["response_data"]["list_of_rootcause"]!.map((x) => ListOfRootcause.fromJson(x))),
        );
    }

}

class ListOfRootcause extends ListrootcauseEntity {
    ListOfRootcause({required this.incrcmid,
    required this.incrcmincmid,
    required this.incrcmmpmid,
    required this.incrcmrootcausebrief,
    required this.increcmrootcausedetails 
    }):super(
      incrcmid: incrcmid,incrcmincmid: incrcmincmid,incrcmmpmid: incrcmmpmid,incrcmrootcausebrief: incrcmrootcausebrief,increcmrootcausedetails: increcmrootcausedetails

    );

final String ? increcmrootcausedetails;
final String? incrcmrootcausebrief;
final int?incrcmid;
final int?incrcmincmid;
final int?incrcmmpmid;


    factory ListOfRootcause.fromJson(Map<String, dynamic> json){ 
        return ListOfRootcause(    
increcmrootcausedetails :json[ "incrcm_rootcause_details"],
  incrcmrootcausebrief: json[ "incrcm_rootcause_brief"],
    incrcmid :   json["incrcm_id"],
    incrcmincmid:   json["incrcm_incm_id"],
     incrcmmpmid:  json[ "incrcm_mpm_id"] 
        );
    }


}