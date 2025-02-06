import 'package:flutter/material.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/product_avilable_qty_datasource.dart';
import 'package:prominous/features/data/repository/product_avilable_qty_repo.dart';
import 'package:prominous/features/domain/entity/product_avilable_qty_entity.dart';
import 'package:prominous/features/domain/usecase/product_avilable_qty_usecae.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:prominous/features/presentation_layer/provider/product_avilable_qty_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductAvilableQtyService {
  Future<void> getAvilableQty({
    required BuildContext context,
    required int reworkflag,
    required int processid,
    required int paid,
    required String cardno
 
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

      final productQty = ProductAvilableQtyUsecae(
        ProductAvilableQtyRepoImpl(
          ProductAvilableQtyDatasourceImpl(),
        ),
      );

      
final orgid=Provider.of<LoginProvider>(context, listen: false).user?.userLoginEntity?.orgId ?? 0;


      ProductAvilableQtyEntity user = await productQty.execute( token, processid, paid,  cardno, reworkflag, orgid);

      // Update the provider with the fetched data
      Provider.of<ProductAvilableQtyProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}