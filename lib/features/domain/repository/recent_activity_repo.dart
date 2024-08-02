import 'package:prominous/features/domain/entity/recent_activity_entity.dart';

abstract class RecentActivityRepository {
  Future<RecentActivitiesEntity> getRecentActivity(int id,int deptid, int psid, String token);
}
