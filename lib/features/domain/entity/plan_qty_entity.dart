// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:prominous/features/data/model/emp_production_model.dart';
import 'package:prominous/features/data/model/plan_qty_model.dart';

class PlanQtyEntity extends Equatable {
  final PlanQtyCountEntity? planQtyCountEntity;

  const PlanQtyEntity({required this.planQtyCountEntity, PlanQtyCount? actualQtyCountEntity});

  @override
  List<Object?> get props => [planQtyCountEntity];
}

class   PlanQtyCountEntity extends Equatable {
  final int ? planQty;

  const PlanQtyCountEntity(
      {required this.planQty,
});

  @override
  List<Object?> get props => [
        planQty,
      ];

}
