import 'package:prominous/features/data/model/product_avilable_qty_model.dart';
import '../../../../constant/request_data_model/api_request_model.dart';
import '../../core/api_constant.dart';

abstract class ProductAvilableQtyDatasource {
  Future<ProductAvilableQtyModel> getproductQty (String token,int processid,int paid, String cardno,int reworkflag);
}

class ProductAvilableQtyDatasourceImpl extends ProductAvilableQtyDatasource {

  @override
  Future<ProductAvilableQtyModel> getproductQty (String token,int processid,int paid, String cardno,int reworkflag) async {


      ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "item_process_card_wip_v1", clientAuthToken: token,processId:processid ,paId: paid,Cardno:cardno ,reworkflag: reworkflag);
     final response = await ApiConstant.makeApiRequest(requestBody: requestbody);
    final result = ProductAvilableQtyModel.fromJson(response);
   
    return result;
  }
}
