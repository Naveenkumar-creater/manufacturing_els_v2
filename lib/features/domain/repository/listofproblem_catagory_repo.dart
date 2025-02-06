import 'package:prominous/features/domain/entity/listof_problem_entity.dart';

import 'package:prominous/features/domain/entity/listofproblem_catagory_entity.dart';

abstract class ListofproblemCategoryRepository{
 Future<ListOfProblemCategoryEntity> getListofProblemCategory (String token,int deptid,int incidentId, int orgid);
}