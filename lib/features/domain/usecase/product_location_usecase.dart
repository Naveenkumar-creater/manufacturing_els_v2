

import 'package:prominous/features/domain/entity/product_location_entity.dart';
import 'package:prominous/features/domain/repository/product_location_repo.dart';

class ProductLocationUsecase{

  final ProductLocationRepository  productLocationRepository;

  ProductLocationUsecase(this.productLocationRepository);

  Future<ProductLocationEntity> execute(String token) {

    return productLocationRepository.getAreaList(token);


  }


}