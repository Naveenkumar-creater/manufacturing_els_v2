import 'package:prominous/features/domain/entity/plan_qty_entity.dart';

abstract class PlanQtyRepository{
  Future<PlanQtyEntity> getPlanQty(int id,int psid, String token);
}