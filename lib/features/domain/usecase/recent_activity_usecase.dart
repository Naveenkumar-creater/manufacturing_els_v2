import 'package:prominous/features/domain/entity/AllocationEntity.dart';
import 'package:prominous/features/domain/entity/recent_activity_entity.dart';
import 'package:prominous/features/domain/repository/allocation_repo.dart';
import 'package:prominous/features/domain/repository/recent_activity_repo.dart';

class RecentActivityUsecase {
  final RecentActivityRepository recentActivityRepository;

  RecentActivityUsecase(this.recentActivityRepository);

  Future<RecentActivitiesEntity> execute(int id,int deptid,int psid, String token) {
    return recentActivityRepository.getRecentActivity(id, deptid,psid,token);
  }
}