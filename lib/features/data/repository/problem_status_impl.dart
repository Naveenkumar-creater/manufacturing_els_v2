
import 'package:prominous/features/data/datasource/remote/problem_status_datasource.dart';
import 'package:prominous/features/data/model/problem_status_model.dart';

import 'package:prominous/features/domain/repository/problem_status_repo.dart';

class ProblemStatusRepositoryImpl extends ProblemStatusRepository{
  final  ProblemStatusDatasource problemStatusDatasource;
  ProblemStatusRepositoryImpl(this.problemStatusDatasource); 

  @override
  Future<ProblemStatusModel> getProblemStatus(String token, int orgid) async{
   ProblemStatusModel result= await problemStatusDatasource.getProblemStatus(token,  orgid);
    return result;
  }
  
}