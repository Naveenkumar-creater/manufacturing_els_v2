import 'package:prominous/features/domain/entity/actual_qty_entity.dart';
import 'package:prominous/features/domain/entity/plan_qty_entity.dart';
import 'package:prominous/features/domain/repository/actual_qty_repo.dart';
import 'package:prominous/features/domain/repository/plan_qty_repo.dart';

class PlanQtyUsecase{

  final PlanQtyRepository planQtyRepository;
  PlanQtyUsecase(this.planQtyRepository);

  Future<PlanQtyEntity>execute(int id,int psid, String token)async{
return planQtyRepository.getPlanQty(id,psid,token);
  }
}