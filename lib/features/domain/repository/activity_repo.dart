import 'package:prominous/features/domain/entity/activity_entity.dart';

abstract class ActivityRepository{
  Future<ActivityEntity>getActivity(int id,int deptid, String token,int pwsId);
}