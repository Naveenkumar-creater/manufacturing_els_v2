import 'package:prominous/constant/request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/attendance_count.dart';

abstract class AttendanceCountDataSOurce {
  Future<AttendanceCountModel> getAttCount(int id,int deptid,int psid, String token);
}

class AttendanceCountDataSOurceImpl extends AttendanceCountDataSOurce {
  @override
  Future<AttendanceCountModel> getAttCount(int id,int deptid,int psid, String token) async {
    ApiRequestDataModel requestBody = ApiRequestDataModel(
        apiFor: "attendance_count_v1", clientAuthToken: token, processId: id,deptId: deptid,psId: psid);
    final response =
        await ApiConstant.loginApiRequest(requestBody: requestBody);
    final result = AttendanceCountModel.fromJson(response);
    return result;
  }
}
