import 'package:flutter/material.dart';

import 'package:prominous/features/data/datasource/remote/workstation_problem_datasource.dart';

import 'package:prominous/features/data/repository/workstation_problems_repo_impl.dart';

import 'package:prominous/features/domain/entity/workstation_problem_entity.dart';
import 'package:prominous/features/domain/usecase/workstation_problem_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:prominous/features/presentation_layer/provider/workstation_problem_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';


import '../../../constant/utilities/exception_handle/show_pop_error.dart';

class WorkstationProblemService {
  Future<void> getListofProblem({
    required BuildContext context,
    required int pwsid,

  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

      final problems = WorkstationProblemUsecase(
        WorkstationProblemsRepositoryImpl(
          WorkstationProblemDatasourceImpl(),
        ),
      );


final orgid=Provider.of<LoginProvider>(context, listen: false).user?.userLoginEntity?.orgId ?? 0;

   WorkstationProblemsEntity    workstationProblem = await problems.execute(
       pwsid,
        token,
        orgid
      );

      // Update the provider with the fetched data
      Provider.of<WorkstationProblemProvider>(context, listen: false).setUser(workstationProblem);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}