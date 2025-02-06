
import 'package:prominous/features/data/datasource/remote/rootcause_solution_datasource.dart';

import 'package:prominous/features/data/model/rootcause_solution_model.dart';

import 'package:prominous/features/domain/repository/rootcause_solution_repo.dart';


class RootcauseSolutionRepositoryImpl implements RootcauseSolutionRepository {
  final RootcauseSolutionDatasource rootcauseSolutionDatasource;
  RootcauseSolutionRepositoryImpl(
    this.rootcauseSolutionDatasource,
  );
  @override
  Future<RootcauseSolutionModel> getListofSolution(int rootcauseid,int deptid, String token, int orgid) async{
 RootcauseSolutionModel result =
        await rootcauseSolutionDatasource.getListofSolution( rootcauseid,deptid, token,  orgid);
    return result;
  }

}