import 'package:prominous/features/data/model/product_location_model.dart';
import '../../../../constant/request_data_model/api_request_model.dart';
import '../../core/api_constant.dart';

abstract class ProductLocationDatasource {
  Future<ProductLocationModel> getAreaList(String token, int orgid);
}

class ProductLocationDatasourceImpl extends ProductLocationDatasource {
  @override
  Future<ProductLocationModel> getAreaList(String token, int orgid) async{
    
   ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "item_production_area_v1", clientAuthToken: token, orgid: orgid );
     final response = await ApiConstant.makeApiRequest(requestBody: requestbody);
    final result = ProductLocationModel.fromJson(response);

      return result;
  }
}
