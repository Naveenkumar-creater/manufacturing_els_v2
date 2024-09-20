import 'package:http/http.dart';
import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/workstation_problems_model.dart';

abstract class WorkstationProblemDatasource {
  Future<WorkstationProblemsModel>getWorkstationProblemsList(int pwsId, String token);
}

class WorkstationProblemDatasourceImpl implements WorkstationProblemDatasource{
  @override
  Future<WorkstationProblemsModel> getWorkstationProblemsList(int pwsId, String token) async{
  ApiRequestDataModel request =  ApiRequestDataModel(apiFor:"resolved_problem_in_ws_v1" ,clientAuthToken: token,pwsid: pwsId,);
 
 final response=await ApiConstant.makeApiRequest(requestBody: request);

 final result=WorkstationProblemsModel.fromJson(response);
 
 return result;
 
  }
  

}