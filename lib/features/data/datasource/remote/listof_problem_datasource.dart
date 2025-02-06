import 'package:http/http.dart';
import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/listof_problem_model.dart';

abstract class ListofProblemDatasource{

Future<ListOfProblemModel> getListofProblem(String token,int deptid,int processid,int assetId, int orgid);
 
}


class ListofProblemDatasourceImpl implements ListofProblemDatasource{
  @override
  Future<ListOfProblemModel> getListofProblem(String token, int deptid, int processid,int assetId, int orgid) async{
   ApiRequestDataModel requestbody =ApiRequestDataModel(apiFor: "list_of_incident_v1",clientAuthToken:token,deptId:deptid,processId: processid,problemAssetId:assetId, orgid: orgid );
   print(requestbody);
   final response = await ApiConstant.makeApiRequest(requestBody:requestbody );
   final result= ListOfProblemModel.fromJson(response);
 return result;

  }
  
}