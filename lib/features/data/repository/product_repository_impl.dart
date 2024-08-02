import 'package:prominous/features/data/datasource/remote/product_datasource.dart';
import '../../domain/repository/product_repository.dart';
import '../model/product_model.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductDatasource productDatasource;

  ProductRepositoryImpl(this.productDatasource);
  @override
  Future<ProductModel> getProductList(int id,int deptid, String token) {
    final result = productDatasource.getProductList(id,deptid,token);
    return result;
  }
}
