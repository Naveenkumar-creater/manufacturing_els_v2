import 'package:prominous/features/domain/entity/product_avilable_qty_entity.dart';
import 'package:prominous/features/domain/repository/product_avilable_qty_repo.dart';

class ProductAvilableQtyUsecae {
  final ProductAvilableQtyRepo productAvilableQtyRepo;
  ProductAvilableQtyUsecae(this.productAvilableQtyRepo);

  Future<ProductAvilableQtyEntity> execute(
 String token,int processid,int paid, String cardno,int reworkflag, int orgid
  ) async {
    return productAvilableQtyRepo.getproductQty ( token, processid, paid,  cardno, reworkflag,  orgid);
  }
}
