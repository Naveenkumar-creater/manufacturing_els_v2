import 'package:flutter/cupertino.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/listof_problem_datasource.dart';
import 'package:prominous/features/data/datasource/remote/listofrootcause_datasource.dart';
import 'package:prominous/features/data/repository/listofrootcause_repo_impl.dart';
import 'package:prominous/features/domain/entity/listof_rootcause_entity.dart';
import 'package:prominous/features/domain/usecase/listofrootcause_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/listofrootcause_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListofRootCauseService{
  Future getListofRootcause({
    required BuildContext context,
   required  int deptid,
   required int incidentid
  })async{

    try {

      SharedPreferences pref= await SharedPreferences.getInstance();

      String token=pref.getString("client_token")?? "";

       final listofusecase = ListofRootCauseUsecase(
        ListofRootcauseRepoImpl(ListofRootCauseDatasourceImpl(),)
       );

       ListOfRootCauseEntity user=await listofusecase.execute(token, deptid, incidentid);

        Provider.of<ListofRootcauseProvider>(context, listen: false).setUser(user);
      
    } catch (e) {

      ShowError.showAlert(context, e.toString());
      
    }

  }
}