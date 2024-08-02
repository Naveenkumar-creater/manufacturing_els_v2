import 'package:prominous/features/data/model/shift_status_model.dart';

import '../../../../constant/request_model.dart';
import '../../core/api_constant.dart';

abstract class ShiftStatusDatasource {
  Future<ShiftStatusModel> getShiftStatus(int deptid,int processid, String token);
}

class ShiftStatusDatasourceImpl extends ShiftStatusDatasource {

  @override
  Future<ShiftStatusModel> getShiftStatus(int deptid,int processid, String token) async {
  
      ApiRequestDataModel requestbody = ApiRequestDataModel(
          apiFor: "shift_status_v1", clientAuthToken: token,deptId:deptid, processId: processid);
     final response = await ApiConstant.makeApiRequest(requestBody: requestbody);
    final result = ShiftStatusModel.fromJson(response);
      print(result);
      return result;
  }
}