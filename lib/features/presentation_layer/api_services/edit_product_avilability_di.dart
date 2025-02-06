import 'package:flutter/material.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/edit_product_avilability_datasource.dart';
import 'package:prominous/features/data/repository/edit_product_avilabilty_repo_impl.dart';
import 'package:prominous/features/domain/entity/edit_product_avilabilty_entity.dart';
import 'package:prominous/features/domain/usecase/edit_product_avilability_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/edit_product_avilability_provider.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProductAvilableQtyService {
  Future<void> getEditAvilableQty({
    required BuildContext context,
    required int reworkflag,
    required int processid,
    required int paid,
    required String cardno,
    required int ipdid
 
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

      final productQty = EditProductAvilabilityUsecase(
        EditProductAvilabiltyRepoImpl(
          EditProductAvilableQtyDatasourceImpl(),
        ),
      );
      
      int? orgid=Provider.of<LoginProvider>(context, listen: false).user?.userLoginEntity?.orgId  ?? 0;

      EditProductAvilabiltyEntity user = await productQty.execute( token, processid, paid,  cardno, reworkflag, ipdid, orgid);

      // Update the provider with the fetched data
      Provider.of<EditProductAvilableQtyProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}