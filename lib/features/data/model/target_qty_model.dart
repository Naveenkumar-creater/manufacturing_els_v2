
import 'package:prominous/features/domain/entity/target_qty_entity.dart';


class TargetQtyModel extends TargetQtyEntity {
  TargetQtyModel({
    required this.targetQty,
  }) : super(targetQty: targetQty);

  final TargetQty? targetQty;

  factory TargetQtyModel.fromJson(Map<String, dynamic> json) {
    return TargetQtyModel(
      targetQty: json["response_data"]["targetQty"] == null ? null // Set default value if Actual_Qty is null
          : TargetQty.fromJson(json["response_data"]["targetQty"]),
    );
  }
}

class TargetQty extends TargetQty1 {
  TargetQty({
    required this.targetqty,
    required this.ppid,
    required this.achivedtargetqty
  }) : super(targetqty: targetqty ?? 0,
  ppid:ppid,
  achivedtargetqty:achivedtargetqty
  ); // Ensure actualQty is not null

  final int? targetqty;
  final int? ppid;
  final int?achivedtargetqty;

  factory TargetQty.fromJson(Map<String, dynamic> json) {
    return TargetQty(
       ppid: json["pp_id"] ?? 0,
      targetqty: json["target_qty"] ?? 0,
      achivedtargetqty:json["ach_target_qty"] // Provide a default value if Actual_qty is null
    );
  }

 
}

     