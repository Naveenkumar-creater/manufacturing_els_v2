import 'package:prominous/features/domain/entity/product_entity.dart';


abstract class ProductRepository{
  Future<ProductEntity>getProductList(int id,int deptid,String token);
}