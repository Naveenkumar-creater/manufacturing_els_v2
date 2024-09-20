import 'package:prominous/features/domain/entity/workstation_problem_entity.dart';
import 'package:prominous/features/domain/repository/workstation_problem_repo.dart';

class WorkstationProblemUsecase {
   WorkstationProblemRepository  workstationProblemRepository;
 WorkstationProblemUsecase(this.workstationProblemRepository);

 Future<WorkstationProblemsEntity> execute( int pwsid, String token){

  return workstationProblemRepository.getResolveProblemList(pwsid,  token);
  
 }
}