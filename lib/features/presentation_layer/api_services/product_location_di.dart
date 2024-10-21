import 'package:flutter/cupertino.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';
import 'package:prominous/features/data/datasource/remote/product_location_datasource.dart';
import 'package:prominous/features/data/repository/product_location_repo_impl.dart';
import 'package:prominous/features/domain/entity/product_location_entity.dart';
import 'package:prominous/features/domain/usecase/product_location_usecase.dart';
import 'package:prominous/features/presentation_layer/provider/product_location_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductLocationService {
  Future<void> getAreaList({
 required BuildContext context,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

      final productLocation = ProductLocationUsecase(
        ProductLocationRepoImpl(
          ProductLocationDatasourceImpl(),
        ),
      );

      ProductLocationEntity user = await productLocation.execute( token);

      // Update the provider with the fetched data
      Provider.of<ProductLocationProvider>(context, listen: false).setUser(user);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }
}

class ProductLocationUsecae {
}