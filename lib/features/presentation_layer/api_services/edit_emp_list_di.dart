import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/edit_emp_list_datasource.dart';
import 'package:prominous/features/data/repository/edit_emp_list_repo_impl.dart';
import 'package:prominous/features/domain/entity/edit_emp_list_entity.dart';
import 'package:prominous/features/domain/usecase/edit_emp_list_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/edit_emp_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditEmpListApiservice{
  Future<void>getEditEmplist({
      required BuildContext context,
    required int ipdid,
    required int psid
  })async {
    try {
      SharedPreferences   pref=await SharedPreferences.getInstance();
      final token =pref.getString("client_token") ?? "";

      final editListofEmpusecase=EditListofEmpworkstationUsecase(
    EditListofEmpworkstationRepoImpl(
      EditListOfEmpWorkstationDatatsourceImpl( )
    )
      );

      EditListofEmpWorkstationEntity editListofEmployee =await editListofEmpusecase.execute(ipdid, token, psid);

      Provider.of<EditEmpListProvider>(context,listen: false).setUser(editListofEmployee);
    } catch (e) {
        ShowError.showAlert(context, e.toString());
      rethrow;
    }

  }
}