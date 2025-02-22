import 'package:flutter/material.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/attendance_count_datasource.dart';
import 'package:prominous/features/data/repository/attendance_count_repository_impl.dart';
import 'package:prominous/features/domain/usecase/attendance_count.dart';
import 'package:prominous/features/presentation_layer/provider/attendance_count_provider.dart';

class AttendanceCountService {
  Future<void> getAttCount({required BuildContext context, required int id,required int deptid,required int psid}) async {
    try {
      SharedPreferences shref = await SharedPreferences.getInstance();
      String token = shref.getString("client_token") ?? "";
      final attendanceCountUseCases = AttendanceCountUseCases(
          AttendanceCountRepositoryImpl(AttendanceCountDataSOurceImpl()));
int? orgid=Provider.of<LoginProvider>(context, listen: false).user?.userLoginEntity?.orgId  ?? 0;
      final user = await attendanceCountUseCases.execute(id, deptid, psid, token,orgid);

      Provider.of<AttendanceCountProvider>(context, listen: false)
          .setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}
