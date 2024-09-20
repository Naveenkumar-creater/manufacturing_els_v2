import 'package:prominous/features/data/datasource/remote/listof_problem_datasource.dart';
import 'package:prominous/features/domain/entity/listof_problem_entity.dart';
import 'package:prominous/features/domain/repository/listofproblem_repo.dart';

class ListofproblemRepoImpl extends ListofproblemRepository {
 final ListofProblemDatasourceImpl listofProblemDatasourceImpl;
 ListofproblemRepoImpl(this.listofProblemDatasourceImpl);

  @override
  Future<ListOfProblemEntity> getListofProblem(String token, int deptid, int processid,int assetId) async{
   return await listofProblemDatasourceImpl.getListofProblem(token, deptid, processid,assetId);
  }
  
}