import 'package:prominous/features/data/model/recent_activity_model.dart';

import '../../../../constant/request_data_model/api_request_model.dart';
import '../../core/api_constant.dart';

abstract class RecentActivityDatasource {
  Future<RecentActivitiesModel> getRecentActivity(int id,int deptid,int psid, String token,int orgid);
}

class RecentActivityDatasourceImpl extends RecentActivityDatasource {
  // final AllocationClient allocationClient;

  // RecentActivityDatasourceImpl(this.allocationClient);
  @override
  Future<RecentActivitiesModel> getRecentActivity(int id,deptid,psid, String token, int orgid) async {
    // final response = await allocationClient.getallocation(id, token);

    // final result = AllocationModel.fromJson(response);

    // return result;

      ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "recent_activities_v1", clientAuthToken: token, pwsid: id,deptId: deptid, psId: psid, orgid: orgid);
     final response = await ApiConstant.makeApiRequest(requestBody: requestbody);
    final result = RecentActivitiesModel.fromJson(response);
      print(result);
      return result;
  }
}
