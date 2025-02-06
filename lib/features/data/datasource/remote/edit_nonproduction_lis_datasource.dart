import 'package:http/http.dart';
import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/edit_non_production_lis_model.dart';

abstract class EditNonproductionListDatasource{

Future<EditNonProductionLisModel> getEditNonProductionList(String token,int ipdid, int orgid);
 
}


class EditNonproductionListDatasourceImpl implements EditNonproductionListDatasource{
  @override
  Future<EditNonProductionLisModel> getEditNonProductionList(String token,int ipdid, int orgid) async{
   ApiRequestDataModel requestbody =ApiRequestDataModel(apiFor: "edit_list_of_non_production_activity_v1",clientAuthToken:token,ipdid: ipdid, orgid: orgid);
   final response = await ApiConstant.makeApiRequest(requestBody:requestbody );
   final result= EditNonProductionLisModel.fromJson(response);
    return result;
  }
  
}