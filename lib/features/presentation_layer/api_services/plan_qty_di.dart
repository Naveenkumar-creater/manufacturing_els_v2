import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/constant/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/actual_qty_datasource.dart';
import 'package:prominous/features/data/datasource/remote/plan_qty_datasource.dart';
import 'package:prominous/features/data/repository/actual_qty_repo_impl.dart';
import 'package:prominous/features/data/repository/plan_qty_repo_impl.dart';
import 'package:prominous/features/domain/entity/actual_qty_entity.dart';
import 'package:prominous/features/domain/entity/plan_qty_entity.dart';
import 'package:prominous/features/domain/repository/actual_qty_repo.dart';


import 'package:prominous/features/domain/usecase/actual_qty_usecase.dart';
import 'package:prominous/features/domain/usecase/plan_qty_usecase.dart';

import 'package:prominous/features/presentation_layer/provider/actual_qty_provider.dart';
import 'package:prominous/features/presentation_layer/provider/plan_qty_provider.dart';


class PlanQtyService {
  Future<void> getPlanQty(
      {required BuildContext context, required int id,required int psid}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      String token = pref.getString("client_token") ?? "";
      //  ActualQtyDatasource empData = ActualQtyDatasourceImpl();
      // ActualQtyRepository allocationRepository =
      //     ActualQtyRepositoryImpl(empData);
      // ActualQtyUsecase empUseCase = ActualQtyUsecase(allocationRepository);
         final recentActivityUseCase = PlanQtyUsecase(
      PlanQtyRepositoryImpl(
          PlanQtyDatasourceImpl(),
        ),
      );

      PlanQtyEntity user = await recentActivityUseCase.execute(id,psid,token);

      Provider.of<PlanQtyProvider>(context, listen: false).setUser(user);

    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}
