import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/features/data/core/process_client.dart';
import 'package:prominous/features/data/datasource/remote/process_datasource.dart';
import 'package:prominous/features/data/datasource/remote/target_qty_datasource.dart';
import 'package:prominous/features/data/repository/target_qty_repo_impl.dart';
import 'package:prominous/features/domain/entity/process_entity.dart';
import 'package:prominous/features/domain/entity/target_qty_entity.dart';
import 'package:prominous/features/domain/usecase/target_qty_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/process_provider.dart';
import 'package:prominous/features/presentation_layer/provider/target_qty_provider.dart';
import '../../../constant/show_pop_error.dart';

import '../../data/repository/process_repository_impl.dart';
import '../../domain/repository/process_repository.dart';
import '../../domain/usecase/process_usecase.dart';

class TargetQtyApiService {
  Future<void> getTargetQty({
    required BuildContext context,
    required int paId,required int deptid,required int psid,required int pwsid
    //required emp_mgr,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";
      // ProcessClient employeeClient = ProcessClient();
      // ProcessDatasource empData = ProcessDatasourceImpl(employeeClient);
      // ProcessRepository allocationRepository = ProcessRepositoryImpl(empData);
      // ProcessUsecase empUseCase = ProcessUsecase(allocationRepository);


      
         final targetQtyusecase = TargetQtyUsecase(

        TargetQtyRepoImpl(
          TargetQtyDatasourceImpl(),
        ),
      );

      TargetQtyEntity user = await targetQtyusecase.execute(paId,  deptid, psid, pwsid, token);

      Provider.of<TargetQtyProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
      rethrow;
    }
  }
}
