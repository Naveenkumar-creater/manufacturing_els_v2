import 'package:flutter/cupertino.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/listofproblem_catagory_datasource.dart';
import 'package:prominous/features/data/repository/listofproblem_catagory_repo_impl.dart';
import 'package:prominous/features/domain/entity/listofproblem_catagory_entity.dart';
import 'package:prominous/features/domain/usecase/listofproblem_catagory_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/listofproblem_catagory_provider.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListofproblemCategoryservice {
  Future<void> getListofProblemCategory({
    required BuildContext context,
    required int deptid,
    required int incidentid,

  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

      final listofusecase = ListofproblemCategoryUsecase(
        ListofproblemCategoryRepoImpl(
          ListofProblemCategoryDatasourceImpl(),
        ),
      );
int? orgid=Provider.of<LoginProvider>(context, listen: false).user?.userLoginEntity?.orgId  ?? 0;

      ListOfProblemCategoryEntity user = await listofusecase.execute(token,deptid,incidentid,orgid );

      // Update the provider with the fetched data
      Provider.of<ListofproblemCategoryProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}