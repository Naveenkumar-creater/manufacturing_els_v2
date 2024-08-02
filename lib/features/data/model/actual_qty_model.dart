import 'package:prominous/features/domain/entity/actual_qty_entity.dart';

class ActualQuantityModel extends ActualQtyEntity {
  ActualQuantityModel({
    required this.actualQty,
  }) : super(actualQtyCountEntity: actualQty);

  final ActualQty? actualQty;

  factory ActualQuantityModel.fromJson(Map<String, dynamic> json) {
    return ActualQuantityModel(
      actualQty: json["response_data"]["Actual_Qty"].isEmpty  
          ? ActualQty(actualQty: 0) // Set default value if Actual_Qty is null
          : ActualQty.fromJson(json["response_data"]["Actual_Qty"]),
    );
  }
}

class ActualQty extends ActualQtyCountEntity {
  ActualQty({
    required this.actualQty,
  }) : super(actualQty: actualQty ?? 0); // Ensure actualQty is not null

  final int? actualQty;

  factory ActualQty.fromJson(Map<String, dynamic> json) {
    return ActualQty(
      actualQty: json["Actual_qty"] ?? 0, // Provide a default value if Actual_qty is null
    );
  }

  Map<String, dynamic> toJson() => {
    "Actual_qty": actualQty,
  };
}
