import 'package:flutter/material.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/activity_datasource.dart';
import 'package:prominous/features/data/repository/activity_repo_impl.dart';

import 'package:prominous/features/domain/usecase/activity_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/activity_provider.dart';


class ActivityService {
  Future<void> getActivity(
      {required BuildContext context, required int id,required int deptid,required int pwsId}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

         final recentActivityUseCase = ActivityUsecase(
        ActivityRepositoryImpl(
          ActivityDatasourceImpl(),
        ),
      );

      int? orgid=Provider.of<LoginProvider>(context, listen: false).user?.userLoginEntity?.orgId  ?? 0;

      final user = await recentActivityUseCase.execute(id,deptid,token,pwsId,orgid);

      Provider.of<ActivityProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}
