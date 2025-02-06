import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/problem_status_model.dart';


abstract class ProblemStatusDatasource {
  Future<ProblemStatusModel> getProblemStatus(String token, int orgid);
}


class ProblemStatusDatasourceImpl implements ProblemStatusDatasource{

  @override
   Future<ProblemStatusModel> getProblemStatus(String token, int orgid) async{
   ApiRequestDataModel requestbody =ApiRequestDataModel(apiFor: "problem_status_v1",clientAuthToken:token, orgid: orgid);
   final response = await ApiConstant.makeApiRequest(requestBody:requestbody );
   final result= ProblemStatusModel.fromJson(response);
   return result;

  }
  
}