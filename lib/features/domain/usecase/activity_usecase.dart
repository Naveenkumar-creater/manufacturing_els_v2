import 'package:prominous/features/domain/entity/activity_entity.dart';
import 'package:prominous/features/domain/repository/activity_repo.dart';

class ActivityUsecase{
  final ActivityRepository activityRepository;
  ActivityUsecase(this.activityRepository);

  Future<ActivityEntity>execute(int id,int deptid, String token,int pwsId,int orgid)async{
    
    return activityRepository.getActivity(id, deptid, token, pwsId, orgid);
  }

}