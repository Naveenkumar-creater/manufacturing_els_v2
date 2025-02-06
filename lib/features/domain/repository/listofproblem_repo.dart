import 'package:prominous/features/domain/entity/listof_problem_entity.dart';

abstract class ListofproblemRepository{
 Future<ListOfProblemEntity> getListofProblem (String token,int deptid,int processid,int assetId, int orgid);
}