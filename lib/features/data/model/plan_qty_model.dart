import 'package:prominous/features/domain/entity/actual_qty_entity.dart';
import 'package:prominous/features/domain/entity/plan_qty_entity.dart';

class PlanQuantityModel extends PlanQtyEntity {
  PlanQuantityModel({
    required this.planCountQty,
  }) : super(planQtyCountEntity:planCountQty );

  final PlanQtyCount? planCountQty;

  factory PlanQuantityModel.fromJson(Map<String, dynamic> json) {
    return PlanQuantityModel(
      planCountQty: json["response_data"]["Planned_Qty"] == null 
          ? PlanQtyCount(planQty: 0) // Set default value if Actual_Qty is null
          : PlanQtyCount.fromJson(json["response_data"]["Planned_Qty"]),
    );
  }
}

class PlanQtyCount extends PlanQtyCountEntity {
  PlanQtyCount({
    required this.planQty,
  }) : super(planQty: planQty ?? 0); // Ensure actualQty is not null

  final int? planQty;

  factory PlanQtyCount.fromJson(Map<String, dynamic> json) {
    return PlanQtyCount(
      planQty: json["plan_qty"] ?? 0, // Provide a default value if Actual_qty is null
    );
  }

}
