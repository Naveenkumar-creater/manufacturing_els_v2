import 'package:prominous/features/domain/entity/edit_product_avilabilty_entity.dart';

abstract class EditProductAvilableQtyRepo {
  Future<EditProductAvilabiltyEntity> getEditproductQty (String token,int processid,int paid, String cardno,int reworkflag,int ipdid);
}