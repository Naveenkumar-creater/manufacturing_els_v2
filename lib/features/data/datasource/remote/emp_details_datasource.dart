// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/model/process_model.dart';

import '../../core/emp_details_client.dart';
import '../../model/emp_details__model.dart';

abstract class EmpDetailsDatasource {
  Future<EmpDetailsModel> getEmpDetails(String token, int orgid);
}

class EmpDetailsDatasourceImpl implements EmpDetailsDatasource {
  EmpDetailsClient empDetailsClient;
  EmpDetailsDatasourceImpl(
    this.empDetailsClient,
  );
  @override
  Future<EmpDetailsModel> getEmpDetails(String token, int orgid) async {
    final response = await empDetailsClient.getEmpDetails(token, orgid);

    final result = EmpDetailsModel.fromJson(response);

    return result;
  }
}
