import 'package:prominous/features/domain/entity/product_entity.dart';
import 'package:prominous/features/domain/repository/product_repository.dart';

class ProductUsecase{
  final ProductRepository productRepository;
  ProductUsecase(this.productRepository);

  Future<ProductEntity>execute(int id,int deptid, String token)async{
return  productRepository.getProductList(id,deptid, token);
  }
}