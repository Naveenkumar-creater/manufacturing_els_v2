import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:prominous/constant/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/edit_entry_datasource.dart';
import 'package:prominous/features/data/repository/edit_entry_repo_impl.dart';
import 'package:prominous/features/domain/entity/edit_entry_entity.dart';
import 'package:prominous/features/domain/usecase/edit_entry_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/edit_entry_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditEntryApiservice{

  Future<void>getEntryValues({
      required BuildContext context,
    required int psId,
    required int ipdid,
    required int pwsId,
     required int deptid
  })async {
    try {
      SharedPreferences   pref=await SharedPreferences.getInstance();
      final token =pref.getString("client_token") ?? "";

      final editEntryusecase=EditEntryUsecase(
    EditEntryRepoImpl(
      EditEntryDatasourceImpl( )
    )
      );

      EditEntryEntity editEntry =await  editEntryusecase.execute(ipdid, pwsId, psId, deptid, token);

      Provider.of<EditEntryProvider>(context,listen: false).setUser(editEntry);
    } catch (e) {
        ShowError.showAlert(context, e.toString());
      rethrow;
    }

  }
}