import 'package:prominous/features/domain/entity/edit_product_avilabilty_entity.dart';
import 'package:prominous/features/domain/repository/edit_product_avilability_repo.dart';

class EditProductAvilabilityUsecase {
  final EditProductAvilableQtyRepo editProductAvilableQtyRepo;
  EditProductAvilabilityUsecase(this.editProductAvilableQtyRepo);

  Future<EditProductAvilabiltyEntity> execute(
 String token,int processid,int paid, String cardno,int reworkflag,int ipdid, int orgid
  ) async {
    return editProductAvilableQtyRepo.getEditproductQty(token, processid, paid, cardno, reworkflag, ipdid,  orgid);
  }
}
