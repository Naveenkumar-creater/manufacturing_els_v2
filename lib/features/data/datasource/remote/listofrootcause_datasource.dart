import 'package:http/http.dart';
import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/listof_problem_model.dart';
import 'package:prominous/features/data/model/listof_rootcaue_model.dart';

abstract class ListofRootCauseDatasource{

Future<ListOfRootCauseModel> getListofRootcause(String token,int deptid,int incidentid);
 
}


class ListofRootCauseDatasourceImpl implements ListofRootCauseDatasource{

  @override
  Future<ListOfRootCauseModel> getListofRootcause(String token, int deptid, int incidentid) async{
   ApiRequestDataModel requestbody =ApiRequestDataModel(apiFor: "list_of_incident_rootcause_v1",clientAuthToken:token,deptId:deptid,incidentid: incidentid);
   final response = await ApiConstant.makeApiRequest(requestBody:requestbody );
   final result= ListOfRootCauseModel.fromJson(response);
   return result;

  }
  
}