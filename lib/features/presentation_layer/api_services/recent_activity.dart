import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/constant/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/recent_activity_datasource.dart';
import 'package:prominous/features/data/repository/allocation_repo_impl.dart';
import 'package:prominous/features/data/repository/recent_activity_repo_impl.dart';
import 'package:prominous/features/domain/usecase/allocation_usecase.dart';
import 'package:prominous/features/domain/usecase/recent_activity_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/allocation_provider.dart';
import 'package:prominous/features/presentation_layer/provider/recent_activity_provider.dart';

import '../../data/core/allocation_client.dart';
import '../../data/datasource/remote/allocation_datasource.dart';
import '../../domain/entity/AllocationEntity.dart';
import '../../domain/repository/allocation_repo.dart';

class   RecentActivityService {
  Future<void> getRecentActivity(
      {required BuildContext context, required int id,required int deptid, required int psid}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";
      // AllocationClient allocationClient = AllocationClient();
      // AllocationDatasource allocationData =
      //     AllocationDatasourceImpl(allocationClient);
      // AllocationRepository allocationRepository =
      //     AllocationRepositoryImpl(allocationData);
      // AllocationUsecases allocationUseCase =
      //     AllocationUsecases(allocationRepository);

      // AllocationEntity user = await allocationUseCase.execute(id, token);


         final recentActivityUseCase = RecentActivityUsecase(
        RecentActivityRepositoryImpl(
          RecentActivityDatasourceImpl(),
        ),
      );

      final user = await recentActivityUseCase.execute(id,deptid,psid, token);

      Provider.of<RecentActivityProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}
