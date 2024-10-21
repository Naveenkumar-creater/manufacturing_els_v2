import 'package:prominous/features/domain/entity/edit_nonproduction_lis_entity.dart';

class   EditNonProductionLisModel extends EditNonProductionListEntity{
    EditNonProductionLisModel({
        required this.listOfNonProductionEntry,
    }):super(listOfNonProductionEntity:listOfNonProductionEntry);

    final List<ListOfNonProductionEntry> listOfNonProductionEntry;

    factory EditNonProductionLisModel.fromJson(Map<String, dynamic> json){ 
        return EditNonProductionLisModel(
            listOfNonProductionEntry: json["response_data"]["Edit_List_Of_Non_Production_Activity"] == null ? [] : List<ListOfNonProductionEntry>.from(json["response_data"]["Edit_List_Of_Non_Production_Activity"]!.map((x) => ListOfNonProductionEntry.fromJson(x))),
        );
    }

}

class ListOfNonProductionEntry extends ListOfNonProductionEntity{
    ListOfNonProductionEntry({
        required this.inpaNpamId,
        required this.inpaToTime,
        required this.inpaNotes,
        required this.npamName,
        required this.inpaFromTime,
        required this.inpaId,
        required this.inpaIpdId,
    }):super(inpaFromTime:inpaFromTime ,inpaId: inpaId,inpaNpamId: inpaNpamId,inpaNotes:inpaNotes ,inpaToTime: inpaToTime,inpsIpdId:inpaIpdId,
    npamName:npamName );

    final int? inpaNpamId;
    final String? inpaToTime;
    final String? inpaNotes;
    final String? npamName;
    final String? inpaFromTime;
    final int? inpaId;
    final int? inpaIpdId;

    factory ListOfNonProductionEntry.fromJson(Map<String, dynamic> json){ 
        return ListOfNonProductionEntry(
            inpaNpamId: json["inpa_npam_id"],
            inpaToTime: json["inpa_to_time"],
            inpaNotes: json["inpa_notes"],
            npamName: json["npam_name"],
            inpaFromTime: json["inpa_from_time"],
            inpaId: json["inpa_id"],
            inpaIpdId: json["inpa_ipd_id"],
        );
    }

}


