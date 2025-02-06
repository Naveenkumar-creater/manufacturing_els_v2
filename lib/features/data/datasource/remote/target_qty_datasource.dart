import 'package:prominous/features/data/model/target_qty_model.dart';

import '../../../../constant/request_data_model/api_request_model.dart';
import '../../core/api_constant.dart';



abstract class TargetQtyDatasource {
  Future<TargetQtyModel> getTargetQty( int paid,int deptid,int psid,int pwsid,
    String token, int orgid);
}




class TargetQtyDatasourceImpl extends TargetQtyDatasource {
  // final AllocationClient allocationClient;

  // RecentActivityDatasourceImpl(this.allocationClient);
  @override
  Future<TargetQtyModel> getTargetQty ( int paid,int deptid,int psid,int pwsid, String token, int orgid)async {
    // final response = await allocationClient.getallocation(id, token);

    // final result = AllocationModel.fromJson(response);

    // return result;

      ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "target_qty_v1", clientAuthToken: token, paId: paid,deptId: deptid,psId:psid,ipdpwsid: pwsid, orgid: orgid);
     final response = await ApiConstant.makeApiRequest(requestBody: requestbody);
    final result = TargetQtyModel.fromJson(response);
      print(result);
      return result;
  }
  
}
