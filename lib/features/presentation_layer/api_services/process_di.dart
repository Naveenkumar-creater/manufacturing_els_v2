import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/features/data/core/process_client.dart';
import 'package:prominous/features/data/datasource/remote/process_datasource.dart';
import 'package:prominous/features/domain/entity/process_entity.dart';
import 'package:prominous/features/presentation_layer/provider/process_provider.dart';
import '../../../constant/show_pop_error.dart';

import '../../data/repository/process_repository_impl.dart';
import '../../domain/repository/process_repository.dart';
import '../../domain/usecase/process_usecase.dart';

class ProcessApiService {
  Future<void> getProcessdetail({
    required BuildContext context,
    required int deptid
    //required emp_mgr,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";
      ProcessClient processClient = ProcessClient();
      ProcessDatasource processDatasource = ProcessDatasourceImpl(processClient);
      ProcessRepository allocationRepository = ProcessRepositoryImpl(processDatasource);
      ProcessUsecase processUsecase = ProcessUsecase(allocationRepository);

      ProcessEntity user = await processUsecase.execute(token,deptid);

      Provider.of<ProcessProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
      rethrow;
    }
  }
}
