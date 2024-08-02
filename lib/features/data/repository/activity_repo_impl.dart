import 'package:prominous/features/data/datasource/remote/activity_datasource.dart';
import 'package:prominous/features/data/model/activity_model.dart';

import 'package:prominous/features/domain/repository/activity_repo.dart';

class ActivityRepositoryImpl extends ActivityRepository{
  final  ActivityDatasource activityDatasource;
  ActivityRepositoryImpl(this.activityDatasource);

  @override
  Future<ActivityModel> getActivity(int id,int deptid, String token,int pwsId) async{
 ActivityModel result= await activityDatasource.getActivity(id, deptid, token, pwsId);
    return result;
  }
  
}