
import 'package:prominous/features/data/datasource/remote/problem_status_datasource.dart';
import 'package:prominous/features/data/datasource/remote/product_avilable_qty_datasource.dart';
import 'package:prominous/features/data/model/problem_status_model.dart';
import 'package:prominous/features/data/model/product_avilable_qty_model.dart';
import 'package:prominous/features/domain/repository/product_avilable_qty_repo.dart';

class ProductAvilableQtyRepoImpl extends ProductAvilableQtyRepo{
  final  ProductAvilableQtyDatasource productAvilableQtyDatasource;
  ProductAvilableQtyRepoImpl(this.productAvilableQtyDatasource); 

  @override
  Future<ProductAvilableQtyModel> getproductQty (String token,int processid,int paid, String cardno,int reworkflag) async{
   ProductAvilableQtyModel result= await productAvilableQtyDatasource.getproductQty ( token, processid, paid,  cardno, reworkflag);
    return result;
  }
  
}