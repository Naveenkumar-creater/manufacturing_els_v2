import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/listofempworkstation_model.dart';
import 'package:prominous/features/data/model/listofworkstation_model.dart';

abstract class ListOfEmpWorkstationDatatsource{
  Future<ListofEmpWorkstationModel>getListofEmpWorkstation( int deptid, int psid, int processid, String token,int pwsId, int orgid);
}


class ListOfEmpWorkstationDatatsourceImpl implements ListOfEmpWorkstationDatatsource{
  @override
  Future<ListofEmpWorkstationModel> getListofEmpWorkstation(int deptid, int psid, int processid, String token,int pwsId,int orgid) async{
    ApiRequestDataModel requestbody= ApiRequestDataModel(apiFor: "list_of_emp_workstation_v1",clientAuthToken: token,deptId: deptid,psId: psid,processId: processid,pwsid:pwsId,orgid: orgid);
 final  response= await ApiConstant.makeApiRequest(requestBody:requestbody );

 final result= ListofEmpWorkstationModel.fromJson(response);

 return result;
  }
}