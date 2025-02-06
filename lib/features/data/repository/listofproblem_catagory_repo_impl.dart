
import 'package:prominous/features/data/datasource/remote/listofproblem_catagory_datasource.dart';
import 'package:prominous/features/data/model/listof_problem_category_model.dart';
import 'package:prominous/features/domain/repository/listofproblem_catagory_repo.dart';



class ListofproblemCategoryRepoImpl extends ListofproblemCategoryRepository {
 final ListofProblemCategoryDatasource listofProblemDatasource;
 ListofproblemCategoryRepoImpl(this.listofProblemDatasource);

  @override
  Future<ListOfProbleCategorymModel> getListofProblemCategory(String token, int deptid, int incidentId, int orgid) async{
   return await listofProblemDatasource.getListofProblemCategory(token, deptid, incidentId,  orgid);
  }  
}