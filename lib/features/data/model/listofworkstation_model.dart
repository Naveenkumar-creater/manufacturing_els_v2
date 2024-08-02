
import 'package:prominous/features/domain/entity/listofworkstation_entity.dart';

class ListOfWorkstationModel extends ListOfWorkstationEntity {
    ListOfWorkstationModel({
        required this.listOfWorkStation,
    }):super(listOfWorkstation: listOfWorkStation);

    final List<ListOfWorkStation> listOfWorkStation;

    factory ListOfWorkstationModel.fromJson(Map<String, dynamic> json){ 
        return ListOfWorkstationModel(
            listOfWorkStation: json['response_data']["List_Of_WorkStation"] == null ? [] : List<ListOfWorkStation>.from(json['response_data']["List_Of_WorkStation"]!.map((x) => ListOfWorkStation.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "List_Of_WorkStation": listOfWorkStation.map((x) => x?.toJson()).toList(),
    };

}

class ListOfWorkStation  extends ListWorkstationEntity{
    ListOfWorkStation({
        required this.noOfStaff,
        required this.mpmName,
        required this.pwsName,
        required this.mpmId,
        required this.pwsId,
        required this.pwseId
    }):super(mpmId: mpmId,mpmName: mpmName,noOfStaff: noOfStaff,pwsId: pwsId,pwsName: pwsName,pwseId:pwseId);

    final int? noOfStaff;
    final String? mpmName;
    final String? pwsName;
    final int? mpmId;
    final int? pwsId;
    final int? pwseId;

    factory ListOfWorkStation.fromJson(Map<String, dynamic> json){ 
        return ListOfWorkStation(
            noOfStaff: json["no_of_staff"],
            mpmName: json["mpm_name"],
            pwsName: json["pws_name"],
            mpmId: json["mpm_id"],
            pwsId: json["pws_id"],
            pwseId:json["pwse_id"]
        );
    }

    Map<String, dynamic> toJson() => {
        "no_of_staff": noOfStaff,
        "mpm_name": mpmName,
        "pws_name": pwsName,
        "mpm_id": mpmId,
        "pws_id": pwsId,
        "pwse_id":pwseId
    };

}
