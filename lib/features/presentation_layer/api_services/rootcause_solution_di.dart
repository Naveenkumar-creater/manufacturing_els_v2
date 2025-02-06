import 'package:flutter/material.dart';
import 'package:prominous/features/data/datasource/remote/rootcause_solution_datasource.dart';
import 'package:prominous/features/data/repository/rootcause_solution_repo_impl.dart';
import 'package:prominous/features/domain/entity/rootcause_solution_entity.dart';
import 'package:prominous/features/domain/usecase/solution_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:prominous/features/presentation_layer/provider/rootcause_solution_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';


import '../../../constant/utilities/exception_handle/show_pop_error.dart';

class RootcauseSolutionService {
  Future<void> getListofSolution({
    required BuildContext context,
    required int deptid,
    required int rootcauseid,

  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

      final solution = RootcauseSolutionUsecase(
        RootcauseSolutionRepositoryImpl(
          RootcauseSolutionDatasourceImpl(),
        ),
      );


final orgid=Provider.of<LoginProvider>(context, listen: false).user?.userLoginEntity?.orgId ?? 0;

      RootcauseSolutionEntity user = await solution.execute(
       rootcauseid,
        deptid,
        token,
        orgid
 
      );

      // Update the provider with the fetched data
      Provider.of<RootcauseSolutionProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}