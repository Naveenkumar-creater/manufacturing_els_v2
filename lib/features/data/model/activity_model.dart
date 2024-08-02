import 'package:prominous/features/domain/entity/activity_entity.dart';

class ActivityModel extends ActivityEntity{
    const ActivityModel({
        required this.activityProduct,
    }):super(activityEntity:activityProduct);

    final List<ProcessActivity> activityProduct;

    factory ActivityModel.fromJson(Map<String, dynamic> json){ 
        return ActivityModel(
            activityProduct: json["response_data"]["Process_Activity"] == null ? [] : List<ProcessActivity>.from(json["response_data"]["Process_Activity"]!.map((x) =>ProcessActivity.fromJson(x))),
        );
    }

    // Map<String, dynamic> toJson() => {
    //     "Allocation_Of_Product": allocationOfProduct.map((x) => x?.toJson()).toList(),
    // };

}

class ProcessActivity extends ProcessActivityEntity {
  ProcessActivity
({
        required this.paActivityName,
        required this.mpmName,
        required this.pwsName,
        required this.paId,
        required this.paMpmId,
    }):super(paActivityName:paActivityName,paId: paId,paMpmId:paMpmId,mpmName:mpmName ,pwsName: pwsName );

    final String? paActivityName;
    final String? mpmName;
    final String? pwsName;
    final int? paId;
    final int? paMpmId;

    factory ProcessActivity.fromJson(Map<String, dynamic> json){ 
        return ProcessActivity(
            paActivityName: json["pa_activity_name"],
            mpmName: json["mpm_name"],
            pwsName: json["pws_name"],
            paId: json["pa_id"],
            paMpmId: json["pa_mpm_id"],
        );
    }

}



