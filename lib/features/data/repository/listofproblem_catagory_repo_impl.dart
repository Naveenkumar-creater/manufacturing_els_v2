import 'package:prominous/features/data/datasource/remote/listofproblem_catagory_datasource.dart';
import 'package:prominous/features/data/model/listof_problem_category_model.dart';
import 'package:prominous/features/domain/repository/listofproblem_catagory_repo.dart';


class ListofproblemCatagoryRepoImpl extends ListofproblemCatagoryRepository {
 final ListofProblemCatagoryDatasourceImpl listofProblemDatasourceImpl;
 ListofproblemCatagoryRepoImpl(this.listofProblemDatasourceImpl);

  @override
  Future<ListOfProbleCatagorymModel> getListofProblemCatagory(String token, int deptid, int incidentId) async{
   return await listofProblemDatasourceImpl.getListofProblemCatagory(token, deptid, incidentId);
  }  
}