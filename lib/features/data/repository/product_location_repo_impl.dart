import 'package:prominous/features/data/datasource/remote/product_location_datasource.dart';
import 'package:prominous/features/data/model/product_location_model.dart';
import 'package:prominous/features/domain/repository/product_location_repo.dart';

class ProductLocationRepoImpl extends ProductLocationRepository{
   ProductLocationDatasource  productLocationDatasource;
   ProductLocationRepoImpl(this.productLocationDatasource);

  @override
  Future<ProductLocationModel> getAreaList(String token,  int orgid) async{
    return await productLocationDatasource.getAreaList(token,  orgid);
  }


}