import 'package:http/http.dart';
import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/listof_problem_category_model.dart';
import 'package:prominous/features/data/model/listof_problem_model.dart';

abstract class ListofProblemCatagoryDatasource{

Future<ListOfProbleCatagorymModel> getListofProblemCatagory(String token,int deptid,int incidentId);
 
}


class ListofProblemCatagoryDatasourceImpl implements ListofProblemCatagoryDatasource{

  @override
  Future<ListOfProbleCatagorymModel> getListofProblemCatagory(String token, int deptid, int incidentId) async{
   ApiRequestDataModel requestbody =ApiRequestDataModel(apiFor: "list_of_incident_category_v1",clientAuthToken:token,deptId:deptid,incidentid: incidentId);
   final response = await ApiConstant.makeApiRequest(requestBody:requestbody );
  final result= ListOfProbleCatagorymModel.fromJson(response);
 return result;

  }
  
}