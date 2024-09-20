
import 'package:prominous/features/data/datasource/remote/non_Production_activity_datasource.dart';
import 'package:prominous/features/data/datasource/remote/plan_qty_datasource.dart';
import 'package:prominous/features/data/model/non_production_activity_model.dart';

import 'package:prominous/features/data/model/plan_qty_model.dart';
import 'package:prominous/features/domain/entity/non_production_activity_entity.dart';
import 'package:prominous/features/domain/repository/non_production_repo.dart';

import 'package:prominous/features/domain/repository/plan_qty_repo.dart';

class NonProductionRepoImpl extends NonProductionRepository{
  final  NonProductionActivityDatasource nonProductionActivityDatasource;
  NonProductionRepoImpl(this.nonProductionActivityDatasource); 
  @override
  Future<NonProductionActivityEntity> getNonProductionActivity(String token) async{
  final  result= await nonProductionActivityDatasource.getNonProductionActivity(token);
    return result;
  }

  
}