import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/features/data/core/process_client.dart';
import 'package:prominous/features/data/datasource/remote/process_datasource.dart';
import 'package:prominous/features/domain/entity/process_entity.dart';
import 'package:prominous/features/domain/repository/emp_details_repository.dart';
import 'package:prominous/features/presentation_layer/provider/emp_details_provider.dart';
import 'package:prominous/features/presentation_layer/provider/process_provider.dart';
import '../../../constant/show_pop_error.dart';

import '../../data/core/emp_details_client.dart';
import '../../data/datasource/remote/emp_details_datasource.dart';
import '../../data/repository/emp_details_repository_impl.dart';
import '../../data/repository/process_repository_impl.dart';
import '../../domain/entity/emp_details_entity.dart';
import '../../domain/repository/process_repository.dart';
import '../../domain/usecase/emp_details_usecase.dart';
import '../../domain/usecase/process_usecase.dart';

class EmpDetailsApiService {
  Future<void> getEmpDetails({
    required BuildContext context,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";
      EmpDetailsClient employeeClient = EmpDetailsClient();
      EmpDetailsDatasource empData = EmpDetailsDatasourceImpl(employeeClient);
      EmpDetailsRepository allocationRepository =
          EmpDetailsRepositoryImpl(empData);
      EmpDetailsUsecase empUseCase = EmpDetailsUsecase(allocationRepository);

      EmpDetailsEntity user = await empUseCase.execute(token);

      Provider.of<EmpDetailsProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
      rethrow;
    }
  }
}
