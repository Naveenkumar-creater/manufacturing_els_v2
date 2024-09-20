import 'package:flutter/material.dart';
import 'package:prominous/features/data/datasource/remote/problem_status_datasource.dart';
import 'package:prominous/features/data/repository/problem_status_impl.dart';
import 'package:prominous/features/domain/entity/problem_status_entity.dart';

import 'package:prominous/features/domain/usecase/problem_usecase.dart';

import 'package:prominous/features/presentation_layer/provider/problem_status_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../../constant/utilities/exception_handle/show_pop_error.dart';

class ProblemStatusService {
  Future<void> getProblemStatus({
    required BuildContext context,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";
      final problemstatus = ProblemStatusUsecase(
        ProblemStatusRepositoryImpl(
          ProblemStatusDatasourceImpl(),
        ),
      );

      ProblemStatusEntity user = await problemstatus.execute(
        token);

      // Update the provider with the fetched data
      Provider.of<ProblemStatusProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}
