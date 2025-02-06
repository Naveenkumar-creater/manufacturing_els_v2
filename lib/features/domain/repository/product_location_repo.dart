
import 'package:prominous/features/domain/entity/product_location_entity.dart';

abstract class ProductLocationRepository{
  Future<ProductLocationEntity>getAreaList(String token,int orgid);
}