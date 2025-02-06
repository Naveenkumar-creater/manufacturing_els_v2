import 'package:prominous/features/data/model/edit_product_avilability_model.dart';
import 'package:prominous/features/data/model/product_avilable_qty_model.dart';
import 'package:prominous/features/data/model/recent_activity_model.dart';

import '../../../../constant/request_data_model/api_request_model.dart';
import '../../core/api_constant.dart';

abstract class EditProductAvilabilityDatasource {
  Future<EditProductAvilableQtyModel> getEditproductQty (String token,int processid,int paid, String cardno,int reworkflag,int ipdid, int orgid);
}

class EditProductAvilableQtyDatasourceImpl extends EditProductAvilabilityDatasource {

  @override
  Future<EditProductAvilableQtyModel> getEditproductQty (String token,int processid,int paid, String cardno,int reworkflag,int ipdid, int orgid) async {

      ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "edit_item_process_card_wip_v1", clientAuthToken: token,processId:processid ,paId: paid,Cardno:cardno ,reworkflag: reworkflag,ipdId:ipdid, orgid: orgid );
     final response = await ApiConstant.makeApiRequest(requestBody: requestbody);
    final result = EditProductAvilableQtyModel.fromJson(response);
    return result;
  }
}
