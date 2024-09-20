import 'package:flutter/material.dart';
import 'package:prominous/features/data/datasource/remote/non_Production_activity_datasource.dart';

import 'package:prominous/features/data/repository/non_production_repo_impl.dart';
import 'package:prominous/features/domain/entity/non_production_activity_entity.dart';

import 'package:prominous/features/domain/usecase/non_production_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/non_production_activity_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../constant/utilities/exception_handle/show_pop_error.dart';

class NonProductionActivityService {
  Future<void> getNonProductionList({
    required BuildContext context,

  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";
      final nonproductionActivity = NonProductionUsecase(
        NonProductionRepoImpl(
          NonProductionActivityDatasourceImpl(),
        ),
      );

      NonProductionActivityEntity user = await nonproductionActivity.execute(
        token,  );

      // Update the provider with the fetched data
      Provider.of<NonProductionActivityProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}
