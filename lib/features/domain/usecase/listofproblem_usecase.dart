import 'package:prominous/features/domain/entity/listof_problem_entity.dart';
import 'package:prominous/features/domain/repository/listofproblem_repo.dart';

class ListofproblemUsecase  {
  final ListofproblemRepository listofproblemRepository;
  ListofproblemUsecase( this.listofproblemRepository);

  Future<ListOfProblemEntity> execute (String token, int deptid, int processid,int assetId) {

   return  listofproblemRepository.getListofProblem(token, deptid, processid,assetId);
  }
  
} 