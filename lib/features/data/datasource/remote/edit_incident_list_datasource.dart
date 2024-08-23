import 'package:http/http.dart';
import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/edit_incident_list.model.dart';
import 'package:prominous/features/data/model/listof_problem_model.dart';

abstract class EditIncidentListDatasource{

Future<EditIncidentListModel> getListofIncident(String token,int deptid,int ipdid);
 
}


class EditIncidentListDatasourceImpl implements EditIncidentListDatasource{

  @override
  Future<EditIncidentListModel> getListofIncident(String token, int deptid, int ipdid) async{
   ApiRequestDataModel requestbody =ApiRequestDataModel(apiFor: "edit_incident_list_v1",clientAuthToken:token,deptId:deptid,ipdid: ipdid);
   final response = await ApiConstant.makeApiRequest(requestBody:requestbody );
  final result= EditIncidentListModel.fromJson(response);
 return result;

  }
  
}