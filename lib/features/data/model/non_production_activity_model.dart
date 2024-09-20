import 'package:prominous/features/domain/entity/non_production_activity_entity.dart';

class NonProductionActivityModel extends NonProductionActivityEntity {
    NonProductionActivityModel({
        required this.nonProductionActivity,
    }):super(nonProductionActivity:nonProductionActivity );

    final List<NonProductionActivity> nonProductionActivity;

    factory NonProductionActivityModel.fromJson(Map<String, dynamic> json){ 
        return NonProductionActivityModel(
            nonProductionActivity: json['response_data']["Non_Production_Activity"] == null ? [] : List<NonProductionActivity>.from(json['response_data']["Non_Production_Activity"]!.map((x) => NonProductionActivity.fromJson(x))),
        );
    }

}

class NonProductionActivity extends NonProductionEntity {
    NonProductionActivity({
        required this.npamId,
        required this.npamName,
    }):super(npamId: npamId,npamName: npamName);

    final int? npamId;
    final String? npamName;

    factory NonProductionActivity.fromJson(Map<String, dynamic> json){ 
        return NonProductionActivity(
            npamId: json["npam_id"],
            npamName: json["npam_name"],
        );
    }

}