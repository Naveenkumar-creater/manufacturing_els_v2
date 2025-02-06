import 'package:flutter/cupertino.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/edit_incident_list_datasource.dart';

import 'package:prominous/features/domain/entity/edit_incident_entity.dart';
import 'package:prominous/features/domain/usecase/edit_incident_list_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/edit_incident_list_provider.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repository/edit_incident_list_impl.dart';

class EditIncidentListService {
  Future<void> getIncidentList({
    required BuildContext context,
    required int deptid,
    required int ipdid,

  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

      final editincidentusecase = EditIncidentListUsecase(
        EditIncidentListRepoImpl(
          EditIncidentListDatasourceImpl(),
        ),
      );
      int? orgid=Provider.of<LoginProvider>(context, listen: false).user?.userLoginEntity?.orgId  ?? 0;

      EditIncidentListEntity user = await editincidentusecase.execute(token,deptid,ipdid, orgid
       
      );

      // Update the provider with the fetched data
      Provider.of<EditIncidentListProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}