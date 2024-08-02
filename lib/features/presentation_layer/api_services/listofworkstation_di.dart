import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prominous/features/data/datasource/remote/listofworkstation_datasource.dart';
import 'package:prominous/features/data/repository/listofworkstation_repo_impl.dart';
import 'package:prominous/features/domain/entity/listofworkstation_entity.dart';
import 'package:prominous/features/domain/usecase/listofworkstation_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:prominous/features/presentation_layer/provider/listofworkstation_provider.dart';

import '../../../../constant/show_pop_error.dart';

class ListofworkstationService {
  Future<void> getListofWorkstation({
    required BuildContext context,
    required int deptid,
    required int psid,
    required int processid,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

      final workstation = ListofworkstationUsecase(
        ListofworkstationRepoImpl(
          ListOfWorkstationDatatsourceImpl(),
        ),
      );

      ListOfWorkstationEntity user = await workstation.execute(
        deptid,
        psid,
        processid,
        token,
      );

      // Update the provider with the fetched data
      Provider.of<ListofworkstationProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}
