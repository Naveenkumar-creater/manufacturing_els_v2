import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/listofworkstation_model.dart';

abstract class ListOfWorkstationDatatsource{
  Future<ListOfWorkstationModel>getListofWorkstation( int deptid, int psid, int processid, String token, int orgid);
}


class ListOfWorkstationDatatsourceImpl implements ListOfWorkstationDatatsource{
  @override
  Future<ListOfWorkstationModel> getListofWorkstation(int deptid, int psid, int processid, String token, int orgid ) async{
    ApiRequestDataModel requestbody= ApiRequestDataModel(apiFor: "list_of_workstation_v1",clientAuthToken: token,deptId: deptid,psId: psid,processId: processid,orgid: orgid);
 final  response= await ApiConstant.makeApiRequest(requestBody:requestbody );

 final result= ListOfWorkstationModel.fromJson(response);

 return result;
  }
}