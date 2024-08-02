import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prominous/features/data/datasource/remote/listofempworkstation_datasource.dart';
import 'package:prominous/features/data/datasource/remote/listofworkstation_datasource.dart';
import 'package:prominous/features/data/repository/listofempworkstation_repo_impl.dart';
import 'package:prominous/features/data/repository/listofworkstation_repo_impl.dart';
import 'package:prominous/features/domain/entity/listofempworkstation_entity.dart';
import 'package:prominous/features/domain/entity/listofworkstation_entity.dart';
import 'package:prominous/features/domain/usecase/listofempworkstation_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/listofempworkstation_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:prominous/features/presentation_layer/provider/listofworkstation_provider.dart';

import '../../../../constant/show_pop_error.dart';

class ListofEmpworkstationService {
  Future<void> getListofEmpWorkstation({
    required BuildContext context,
    required int deptid,
    required int psid,
    required int processid,
    required int pwsId
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

      final empworkstation = ListofEmpworkstationUsecase(
        ListofEmpworkstationRepoImpl(
          ListOfEmpWorkstationDatatsourceImpl(),
        ),
      );

      ListofEmpWorkstationEntity user = await empworkstation.execute(
        deptid,
        psid,
        processid,
        token,
        pwsId
      );

      // Update the provider with the fetched data
      Provider.of<ListofEmpworkstationProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}
