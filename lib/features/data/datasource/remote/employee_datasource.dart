// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:prominous/constant/request_model.dart';

import '../../core/employee_client.dart';
import '../../model/employee_model.dart';

abstract class EmployeeDatasource {
  Future<EmployeeModel> getEmployeeList(int processid, int deptid,int psid,String token);
}

class EmployeeDatasourceImpl extends EmployeeDatasource {
  final EmployeeClient employeeClient;
  EmployeeDatasourceImpl(
    this.employeeClient,
  );
  @override
  Future<EmployeeModel> getEmployeeList(int processid, int deptid,int psid,String token) async {
    final response = await employeeClient.getEmployeeList(processid, deptid,psid,token);

    final result = EmployeeModel.fromJson(response);
        print(result);

    return result;



    // ApiRequestDataModel requestBody = ApiRequestDataModel(
    //     apiFor: "list_of_employees", clientAuthToken: token, processId: id);
    // final response = await ApiConstant.makeApiRequest(requestBody: requestBody);
    // final result = EmployeeModel.fromJson(response);
    // return result;
  }
}
