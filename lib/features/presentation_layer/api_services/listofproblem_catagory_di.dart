import 'package:flutter/cupertino.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/listofproblem_catagory_datasource.dart';
import 'package:prominous/features/data/repository/listofproblem_catagory_repo_impl.dart';
import 'package:prominous/features/domain/entity/listofproblem_catagory_entity.dart';
import 'package:prominous/features/domain/usecase/listofproblem_catagory_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/listofproblem_catagory_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListofproblemCatagoryservice {
  Future<void> getListofProblemCatagory({
    required BuildContext context,
    required int deptid,
    required int incidentid,

  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

      final listofusecase = ListofproblemCatagoryUsecase(
        ListofproblemCatagoryRepoImpl(
          ListofProblemCatagoryDatasourceImpl(),
        ),
      );

      ListOfProblemCatagoryEntity user = await listofusecase.execute(token,deptid,incidentid
       
      );

      // Update the provider with the fetched data
      Provider.of<ListofproblemCatagoryProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}