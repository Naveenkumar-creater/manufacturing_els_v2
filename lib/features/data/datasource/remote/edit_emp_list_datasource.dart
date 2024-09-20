import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/edit_emp_list_model.dart';


abstract class EditListOfEmpWorkstationDatatsource{
  Future<EditListofEmpWorkstationModel>getEditListofEmpWorkstation( int ipdId,String token);
}


class EditListOfEmpWorkstationDatatsourceImpl implements EditListOfEmpWorkstationDatatsource{
  @override
  Future<EditListofEmpWorkstationModel> getEditListofEmpWorkstation( int ipdId,String token) async{
    ApiRequestDataModel requestbody= ApiRequestDataModel(apiFor: "edit_list_of_emp_v1",clientAuthToken: token,ipdid: ipdId);
 final  response= await ApiConstant.makeApiRequest(requestBody:requestbody );

 final result= EditListofEmpWorkstationModel.fromJson(response);

 return result;
  }
}