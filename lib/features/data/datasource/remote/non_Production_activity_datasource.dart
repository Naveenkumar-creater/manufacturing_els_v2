import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/listofworkstation_model.dart';
import 'package:prominous/features/data/model/non_production_activity_model.dart';

abstract class NonProductionActivityDatasource{
  Future<NonProductionActivityModel>getNonProductionActivity(String token, int orgid);
}


class NonProductionActivityDatasourceImpl implements NonProductionActivityDatasource{
  @override
  Future<NonProductionActivityModel> getNonProductionActivity(String token,int orgid) async{
    ApiRequestDataModel requestbody= ApiRequestDataModel(apiFor: "non_production_activity_v1",clientAuthToken: token, orgid: orgid);
 final  response= await ApiConstant.makeApiRequest(requestBody:requestbody );

 final result= NonProductionActivityModel.fromJson(response);

 return result;
  }
}