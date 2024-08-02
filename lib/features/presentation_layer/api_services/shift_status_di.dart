import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/constant/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/shift_status_datasource.dart';
import 'package:prominous/features/data/repository/shift_status_repo_impl.dart';
import 'package:prominous/features/domain/usecase/shift_status_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';


class ShiftStatusService {
  Future<void> getShiftStatus(
      {required BuildContext context, required deptid,required processid}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";


         final recentActivityUseCase = ShiftStatusUsecase(
        ShiftStatusRepositoryImpl(
          ShiftStatusDatasourceImpl(),
        ),
      );

      final user = await recentActivityUseCase.execute(deptid,processid, token);

      Provider.of<ShiftStatusProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}
