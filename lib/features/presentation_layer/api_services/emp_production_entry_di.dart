import 'package:flutter/cupertino.dart';
import 'package:prominous/features/domain/repository/emp_production_entry_repo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/features/data/core/employee_client.dart';
import 'package:prominous/features/data/datasource/remote/emp_production_entry_datasourcel.dart';
import 'package:prominous/features/data/repository/emp_production_entry_repo_impl.dart';
import 'package:prominous/features/domain/entity/emp_production_entity.dart';

import '../../../constant/show_pop_error.dart';
import '../../data/core/emp_production_entry_client.dart';
import '../../data/repository/allocation_repo_impl.dart';
import '../../domain/usecase/emp_production_entry_usecases.dart';
import '../provider/emp_production_entry_provider.dart';

class EmpProductionEntryService {
  Future<void> productionentry({required BuildContext context, required int pwsId,required int deptid, required int psid
      // required int goodQuantities,
      // required int rejectedQuantities,
      // required int reworkQuantities,
      }) async {
    try {
      // final empProductionEntryUseCase = EmpProductionEntryUsecases(
      //   EmpProductionEntryRepoImpl(
      //     EmpProductionEntryDatasourceImpl(),
      //   ),
      // );

      // SharedPreferences pref = await SharedPreferences.getInstance();
      // String token = pref.getString("client_token") ?? "";
      // final productionEntry = await empProductionEntryUseCase.execute(id, token
      // goodQuantities,
      // rejectedQuantities,
      // reworkQuantities,
      //  );
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";
      EmpProductionEntryClient employeeClient = EmpProductionEntryClient();
      EmpProductionEntryDatasource empData =
          EmpProductionEntryDatasourceImpl(employeeClient);
      EmpProductionRepository allocationRepository =
          EmpProductionEntryRepoImpl(empData);
      EmpProductionEntryUsecases empUseCase =
          EmpProductionEntryUsecases(allocationRepository);

      EmpProductionEntity user = await empUseCase.execute(pwsId,deptid,psid, token);

      Provider.of<EmpProductionEntryProvider>(context, listen: false)
          .setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}
