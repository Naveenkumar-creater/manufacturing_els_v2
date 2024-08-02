import 'package:prominous/constant/request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/edit_entry_model.dart';

abstract class EditEntryDatasource {
  Future<EditEntryModel>getEditEntry(int ipdId, int pwsId,int psid, int deptid,String token);
}



class EditEntryDatasourceImpl implements EditEntryDatasource {
  @override
  Future<EditEntryModel> getEditEntry(int ipdId, int pwsId,int psid, int deptid,String token) async{
 ApiRequestDataModel requestbody =ApiRequestDataModel(apiFor: "edit_entry_v1",ipdid: ipdId, pwsid:pwsId, psId:psid, deptId:deptid,clientAuthToken: token );
   final response = await ApiConstant.makeApiRequest(requestBody: requestbody);
  EditEntryModel result=  EditEntryModel.fromJson(response);
  print(result);
  return result;
  }
  
}