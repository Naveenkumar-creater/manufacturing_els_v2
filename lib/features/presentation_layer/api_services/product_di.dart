import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/features/domain/entity/product_entity.dart';
import '../../../constant/show_pop_error.dart';
import '../../data/core/product_client.dart';
import '../../data/datasource/remote/product_datasource.dart';
import '../../data/repository/product_repository_impl.dart';
import '../../domain/repository/product_repository.dart';
import '../../domain/usecase/product_usecase.dart';
import '../provider/product_provider.dart';

class ProductApiService {
   Future<void> productList(
      {required BuildContext context, required int id ,required int deptId}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";
      ProductClient employeeClient = ProductClient();
      ProductDatasource empData = ProductDatasourceImpl(employeeClient);
      ProductRepository allocationRepository = ProductRepositoryImpl(empData);
      ProductUsecase empUseCase = ProductUsecase(allocationRepository);

      ProductEntity user = await empUseCase.execute(id,deptId, token);

      Provider.of<ProductProvider>(context, listen: false).setUser(user);

//       final productUseCase = ProductUsecase(
//         ProductRepositoryImpl(
//           ProductDatasourceImpl(),
//         ),
//       );

//       SharedPreferences pref = await SharedPreferences.getInstance();

//   String token = pref.getString("client_token") ?? "";
//    final product = await productUseCase.execute(id,token);

//       // ignore: use_build_context_synchronously
// Provider.of<ProductProvider>(context, listen: false).setUser(product);
    } catch (e) {
      ShowError.showAlert(context, e.toString());
      rethrow;
    }
  }
}
