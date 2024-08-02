// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:prominous/features/data/datasource/remote/recent_activity_datasource.dart';
import 'package:prominous/features/data/model/recent_activity_model.dart';
import 'package:prominous/features/domain/repository/recent_activity_repo.dart';


class RecentActivityRepositoryImpl implements RecentActivityRepository {
  final RecentActivityDatasource recentActivityDatasource;
  RecentActivityRepositoryImpl(
    this.recentActivityDatasource,
  );


  @override
  Future<RecentActivitiesModel> getRecentActivity(int id,int deptid, int psid, String token) async{
 RecentActivitiesModel modelresult =
        await recentActivityDatasource.getRecentActivity(id, deptid, psid, token);
    return modelresult;
  }
}
