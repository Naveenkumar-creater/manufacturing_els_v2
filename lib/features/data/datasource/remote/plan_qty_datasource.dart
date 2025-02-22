import 'package:prominous/features/data/model/activity_model.dart';
import 'package:prominous/features/data/model/actual_qty_model.dart';
import 'package:prominous/features/data/model/plan_qty_model.dart';
import 'package:prominous/features/data/model/recent_activity_model.dart';

import '../../../../constant/request_data_model/api_request_model.dart';
import '../../core/api_constant.dart';

abstract class PlanQtyDatasource {
  Future<PlanQuantityModel> getPlanQty(int id,int psid, String token, int orgid);
}

class PlanQtyDatasourceImpl extends PlanQtyDatasource {
  // final AllocationClient allocationClient;

  // ActivityDatasourceImpl(this.allocationClient);
  
  
  @override
  Future<PlanQuantityModel> getPlanQty(int id,int psid, String token, int orgid) async{
    
   ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "planned_qty_v1", processId: id,psId: psid, clientAuthToken: token,orgid: orgid );
     final response = await ApiConstant.makeApiRequest(requestBody: requestbody);
    final result = PlanQuantityModel.fromJson(response);
      print(result);
      return result;
  }
}

