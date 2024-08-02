import 'package:flutter/material.dart';
import 'package:prominous/features/presentation_layer/page/loginpage_layout.dart';
import 'package:prominous/features/presentation_layer/provider/actual_qty_provider.dart';
import 'package:prominous/features/presentation_layer/provider/attendance_count_provider.dart';
import 'package:prominous/features/presentation_layer/provider/employee_provider.dart';
import 'package:prominous/features/presentation_layer/provider/listofworkstation_provider.dart';
import 'package:prominous/features/presentation_layer/provider/plan_qty_provider.dart';
import 'package:prominous/features/presentation_layer/provider/process_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/features/data/core/login_api_client.dart';
import 'package:prominous/features/presentation_layer/page/homepage.dart';
import 'package:prominous/features/presentation_layer/page/loginpage.dart';
import 'package:prominous/features/presentation_layer/page/prominous_login_page.dart';
import '../../../constant/show_pop_error.dart';
import '../../data/datasource/remote/login_datasource.dart';
import '../../data/repository/login_repository_impl.dart';
import '../../domain/entity/login_entity.dart';
import '../../domain/repository/login_repository.dart';
import '../../domain/usecase/login_usecase.dart';
import '../provider/login_provider.dart';

class LoginApiService {
 login({
    required BuildContext context,
    required String loginId,
    required String password,
  }) async {
    try {
      LoginApiClient apiClient = LoginApiClient();
      LoginDataSourceImpl loginData =
          LoginDataSourceImpl(apiClient); // Use the LoginDataSourceimpl
      LoginRepository loginRepository = LoginRepositoryImpl(loginData);
      LoginUseCase loginUseCase = LoginUseCase(loginRepository);

      // ApiConstant apiClient = ApiConstant();
      // LoginDataSourceImpl loginData = LoginDataSourceImpl(apiClient);
      // // Use the LoginDataSourceimpl
      // LoginRepository loginRepository = LoginRepositoryImpl(loginData);
      // LoginUseCase loginUseCase = LoginUseCase(loginRepository);

      LoginEntity loginUser = await loginUseCase.execute(loginId, password);

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("client_token", loginUser.userLoginEntity?.clientAutToken ?? "");

      Provider.of<LoginProvider>(context, listen: false).setUser(loginUser);

      // Navigate to homepage after refresh callback
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        result: (route) => false,
      );

      return loginUser;
    } catch (e) {
      ShowError.showAlert(context, e.toString());
      rethrow;
    }
  }

  Future<void> logOutUser(BuildContext context) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString("client_token", "");
       Provider.of<EmployeeProvider>(context, listen: false).reset();
         Provider.of<ActualQtyProvider>(context, listen: false).reset();
           Provider.of<PlanQtyProvider>(context, listen: false).reset();
             Provider.of<AttendanceCountProvider>(context, listen: false).reset();
                    Provider.of<ListofworkstationProvider>(context, listen: false).reset();

  //   context.read<ProcessProvider>().reset();
  // context.read<EmployeeProvider>().reset();
  //  context.read<AttendanceCountProvider>().reset();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginPageLayout()),
    (Route<dynamic> route) => false,
  );
     
    } catch (e) {
      ShowError.showAlert(context, e.toString());
      rethrow;
    }
  }
}
