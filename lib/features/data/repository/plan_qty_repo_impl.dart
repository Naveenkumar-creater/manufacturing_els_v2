
import 'package:prominous/features/data/datasource/remote/plan_qty_datasource.dart';

import 'package:prominous/features/data/model/plan_qty_model.dart';

import 'package:prominous/features/domain/repository/plan_qty_repo.dart';

class PlanQtyRepositoryImpl extends PlanQtyRepository{
  final  PlanQtyDatasource planQtyDatasource;
  PlanQtyRepositoryImpl(this.planQtyDatasource); 

  @override
  Future<PlanQuantityModel> getPlanQty(int id,int psid, String token) async{
   PlanQuantityModel result= await planQtyDatasource.getPlanQty(id,psid, token);
    return result;
  }

  
}