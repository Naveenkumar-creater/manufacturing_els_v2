import 'package:prominous/features/domain/entity/product_avilable_qty_entity.dart';

abstract class ProductAvilableQtyRepo {

  Future<ProductAvilableQtyEntity> getproductQty (String token,int processid,int paid, String cardno,int reworkflag);
}