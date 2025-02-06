import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/listof_rootcaue_model.dart';

abstract class ListofRootCauseDatasource{

Future<ListOfRootCauseModel> getListofRootcause(String token,int deptid,int incidentid, int orgid);
 
}


class ListofRootCauseDatasourceImpl implements ListofRootCauseDatasource{

  @override
  Future<ListOfRootCauseModel> getListofRootcause(String token, int deptid, int incidentid, int orgid) async{
   ApiRequestDataModel requestbody =ApiRequestDataModel(apiFor: "list_of_incident_rootcause_v1", clientAuthToken:token,
   deptId:deptid,incidentid: incidentid, orgid: orgid);
   final response = await ApiConstant.makeApiRequest(requestBody:requestbody );
   final result= ListOfRootCauseModel.fromJson(response);
   return result;

  }
  
}