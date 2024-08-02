import 'package:prominous/features/data/datasource/remote/activity_datasource.dart';
import 'package:prominous/features/data/datasource/remote/actual_qty_datasource.dart';
import 'package:prominous/features/data/model/activity_model.dart';
import 'package:prominous/features/data/model/actual_qty_model.dart';
import 'package:prominous/features/domain/entity/activity_entity.dart';

import 'package:prominous/features/domain/repository/activity_repo.dart';
import 'package:prominous/features/domain/repository/actual_qty_repo.dart';

class ActualQtyRepositoryImpl extends ActualQtyRepository{
  final  ActualQtyDatasource actualQtyDatasource;
  ActualQtyRepositoryImpl(this.actualQtyDatasource); 

  @override
  Future<ActualQuantityModel> getActualQty(int id,int psid, String token) async{
   ActualQuantityModel result= await actualQtyDatasource.getActualQty(id,psid, token);
    return result;
  }

  
}