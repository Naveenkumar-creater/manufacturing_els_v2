import 'package:flutter/cupertino.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/listof_problem_datasource.dart';
import 'package:prominous/features/data/repository/listofproblem_repo_impl.dart';
import 'package:prominous/features/domain/entity/listof_problem_entity.dart';
import 'package:prominous/features/domain/repository/listofproblem_repo.dart';
import 'package:prominous/features/domain/usecase/listofproblem_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/listofproblem_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Listofproblemservice {
  Future<void> getListofProblem({
    required BuildContext context,
    required int deptid,
    required int processid,
 
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

      final listofusecase = ListofproblemUsecase(
        ListofproblemRepoImpl(
          ListofProblemDatasourceImpl(),
        ),
      );

      ListOfProblemEntity user = await listofusecase.execute(token,deptid,processid
       
      );

      // Update the provider with the fetched data
      Provider.of<ListofproblemProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}