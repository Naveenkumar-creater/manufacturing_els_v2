import 'package:prominous/features/data/datasource/remote/workstation_problem_datasource.dart';
import 'package:prominous/features/data/model/workstation_problems_model.dart';
import 'package:prominous/features/domain/entity/workstation_problem_entity.dart';
import 'package:prominous/features/domain/repository/workstation_problem_repo.dart';

class WorkstationProblemsRepositoryImpl extends WorkstationProblemRepository{
  final WorkstationProblemDatasource  workstationProblemDatasource;
  WorkstationProblemsRepositoryImpl(this.workstationProblemDatasource);

  @override
  Future<WorkstationProblemsModel> getResolveProblemList(int pwsid, String token) async{
  WorkstationProblemsModel result= await  workstationProblemDatasource.getWorkstationProblemsList(pwsid,token);
    return result;
  }

}