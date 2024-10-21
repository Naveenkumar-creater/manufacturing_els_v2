
import 'package:prominous/features/data/datasource/remote/edit_product_avilability_datasource.dart';
import 'package:prominous/features/data/model/edit_product_avilability_model.dart';
import 'package:prominous/features/domain/repository/edit_product_avilability_repo.dart';

class EditProductAvilabiltyRepoImpl extends EditProductAvilableQtyRepo{
  final  EditProductAvilabilityDatasource editProductAvilabilityDatasource;
  EditProductAvilabiltyRepoImpl(this.editProductAvilabilityDatasource); 

  @override
  Future<EditProductAvilableQtyModel> getEditproductQty (String token,int processid,int paid, String cardno,int reworkflag,int ipdid) async{
   EditProductAvilableQtyModel result= await editProductAvilabilityDatasource.getEditproductQty(token, processid, paid, cardno, reworkflag, ipdid);
    return result;
  }
  
}