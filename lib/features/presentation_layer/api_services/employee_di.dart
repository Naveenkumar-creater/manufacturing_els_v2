import 'package:flutter/material.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/features/data/core/employee_client.dart';
import 'package:prominous/features/domain/entity/employee_entity.dart';
import 'package:prominous/features/domain/repository/employee_repository.dart';
import '../../../constant/utilities/exception_handle/show_pop_error.dart';
import '../../data/datasource/remote/employee_datasource.dart';
import '../../data/repository/employee_repository_list_impl.dart';
import '../../domain/usecase/employee_usecase.dart';
import '../provider/employee_provider.dart';

class EmployeeApiService {
  Future<void> employeeList(
      {required BuildContext context, required int processid,required int deptid,required int psid}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";
      EmployeeClient employeeClient = EmployeeClient();
      EmployeeDatasource empData = EmployeeDatasourceImpl(employeeClient);
      EmployeeRepository allocationRepository = EmployeeRepositoryImpl(empData);
      EmployeeUsecase empUseCase = EmployeeUsecase(allocationRepository);

      
      int? orgid=Provider.of<LoginProvider>(context, listen: false).user?.userLoginEntity?.orgId  ?? 0;

      EmployeeEntity user = await empUseCase.execute(processid,deptid,psid, token, orgid);

      // final employeeUseCase = EmployeeUsecase(
      //   EmployeeRepositoryImpl(
      //     EmployeeDatasourceImpl(),
      //   ),
      // );

      // SharedPreferences pref = await SharedPreferences.getInstance();

      // String token = pref.getString("client_token") ?? "";
      // final employee = await employeeUseCase.execute(id, token);

      Provider.of<EmployeeProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
      rethrow;
    }
  }
}
