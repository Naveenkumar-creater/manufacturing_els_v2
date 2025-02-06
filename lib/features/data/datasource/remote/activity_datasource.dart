import 'package:prominous/features/data/model/activity_model.dart';
import 'package:prominous/features/data/model/recent_activity_model.dart';

import '../../../../constant/request_data_model/api_request_model.dart';
import '../../core/api_constant.dart';

abstract class ActivityDatasource {
  Future<ActivityModel> getActivity(int id,int deptid, String token,int pwsId, int orgid);
}



class ActivityDatasourceImpl extends ActivityDatasource {
  // final AllocationClient allocationClient;

  // ActivityDatasourceImpl(this.allocationClient);
  
  
  @override
  Future<ActivityModel> getActivity(int id,int deptid, String token,int pwsId,int orgid) async{
   ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "process_activity_v1", clientAuthToken: token, processId: id,deptId: deptid,pwsid:pwsId, orgid: orgid);
     
     final response = await ApiConstant.makeApiRequest(requestBody: requestbody);
    final result = ActivityModel.fromJson(response);
      print(result);
      return result;
  }
  
}
