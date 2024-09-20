import 'package:prominous/constant/request_data_model/api_request_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/rootcause_solution_model.dart';

abstract class RootcauseSolutionDatasource{

Future<RootcauseSolutionModel> getListofSolution(int rootcauseid,int deptid,String token);
 
}

class RootcauseSolutionDatasourceImpl implements RootcauseSolutionDatasource{

  @override
  Future<RootcauseSolutionModel> getListofSolution(int rootcauseid,int deptid,String token) async{
   ApiRequestDataModel requestbody =ApiRequestDataModel(apiFor: "solution_for_rootcause_v1",clientAuthToken:token,deptId:deptid,rootcauseId: rootcauseid);
   final response = await ApiConstant.makeApiRequest(requestBody:requestbody );
   final result= RootcauseSolutionModel.fromJson(response);
   return result;

  }
  
}